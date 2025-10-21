/* Author: Jennifer Stander
 * Course: ECE3829
 * Project: Lab 4
 * Description: Starting project for Lab 4.
 * Implements two functions
 * 1- reading switches and lighting their corresponding LED
 * 2 - It outputs a middle C tone to the AMP2
 * It also initializes the anode and segment of the 7-seg display
 * for future development
 */


// Header Inclusions
/* xparameters.h set parameters names
 like XPAR_AXI_GPIO_0_DEVICE_ID that are referenced in you code
 each hardware module as a section in this file.
*/
#include "xparameters.h"
/* each hardware module type as a set commands you can use to
 * configure and access it. xgpio.h defines API commands for your gpio modules
 */
#include "xgpio.h"
/* this defines the recommend types like u32 */
#include "xil_types.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "sleep.h"
#include "xtmrctr.h"


void check_switches(u32 *sw_data, u32 *sw_data_old, u32 *sw_changes);
void check_buttons(u32 *btn_data, u32 *btn_data_old, u32 *btn_changes);
void update_LEDs(u32 led_data);
void update_amp2(u32 *amp2_data, u32 target_count, u32 *last_count);
void play_note(u32 note_index, u32 duration_ms);
void play_megalovania();


// Block Design Details
/* Timer device ID
 */
#define TMRCTR_DEVICE_ID XPAR_TMRCTR_0_DEVICE_ID
#define TIMER_COUNTER_0 0


/* LED are assigned to GPIO (CH 1) GPIO_0 Device
 * DIP Switches are assigned to GPIO2 (CH 2) GPIO_0 Device
 */
#define GPIO0_ID XPAR_GPIO_0_DEVICE_ID
#define GPIO0_LED_CH 1
#define GPIO0_SW_CH 2
// 16-bits of LED outputs (not tristated)
#define GPIO0_LED_TRI 0x00000000
#define GPIO0_LED_MASK 0x0000FFFF
// 16-bits SW inputs (tristated)
#define GPIO0_SW_TRI 0x0000FFFF
#define GPIO0_SW_MASK 0x0000FFFF

/*  7-SEG Anodes are assigned to GPIO (CH 1) GPIO_1 Device
 *  7-SEG Cathodes are assined to GPIO (CH 2) GPIO_1 Device
 */
#define GPIO1_ID XPAR_GPIO_1_DEVICE_ID
#define GPIO1_ANODE_CH 1
#define GPIO1_CATHODE_CH 2
//4-bits of anode outputs (not tristated)
#define GPIO1_ANODE_TRI 0x00000000
#define GPIO1_ANODE_MASK 0x0000000F
//8-bits of cathode outputs (not tristated)
#define GPIO1_CATHODE_TRI 0x00000000
#define GPIO1_CATHODE_MASK 0x000000FF

// Push buttons are assigned to GPIO (CH_1) GPIO_2 Device
#define GPIO2_ID XPAR_GPIO_2_DEVICE_ID
#define GPIO2_BTN_CH 1
// 4-bits of push button (not tristated)
#define GPIO2_BTN_TRI 0x00000000
#define GPIO2_BTN_MASK 0x0000000F

// AMP2 pins are assigned to GPIO (CH1 1) GPIO_3 device
#define GPIO3_ID XPAR_GPIO_3_DEVICE_ID
#define GPIO3_AMP2_CH 1
#define GPIO3_AMP2_TRI 0xFFFFFFF4
#define GPIO3_AMP2_MASK 0x00000001

// define stuff for the notes
#define CLOCK_FREQ 100000000 // 100 MHz
#define CALC_TARGET_COUNT(f) (CLOCK_FREQ / (2 * (f)))
#define NUM_NOTES 19

u32 note_freqs[NUM_NOTES] = {
    0,                             // OFF
    CALC_TARGET_COUNT(130.81),     // C3
    CALC_TARGET_COUNT(146.83),     // D3
    CALC_TARGET_COUNT(164.81),     // E3
    CALC_TARGET_COUNT(174.61),     // F3
    CALC_TARGET_COUNT(196.00),     // G3
    CALC_TARGET_COUNT(220.00),     // A3
    CALC_TARGET_COUNT(246.94),     // B3
    0,                             // OFF
    CALC_TARGET_COUNT(261.63),     // C4
    CALC_TARGET_COUNT(293.66),     // D4
    CALC_TARGET_COUNT(329.63),     // E4
    CALC_TARGET_COUNT(349.23),     // F4
    CALC_TARGET_COUNT(392.00),     // G4
    CALC_TARGET_COUNT(440.00),     // A4
    CALC_TARGET_COUNT(493.88),     // B4
    0,                             // OFF
    CALC_TARGET_COUNT(523.25),     // C5 (Missing note added)
    CALC_TARGET_COUNT(587.33)      // D5 (Missing note added)
};


// define stuff for the display
u8 note_display[NUM_NOTES] = {
    0xFF, // OFF
    0xC6, // C
    0xA1, // D
    0x86, // E
    0x8E, // F
    0xC2, // G
    0x88, // A
    0x83, // B
    0xFF, // OFF
    0xC6, // C
    0xA1, // D
    0x86, // E
    0x8E, // F
    0xC2, // G
    0x88, // A
    0x83,  // B
    0xFF, // OFF
    0xC6, // C
    0xA1 // D
};

// Timer Device instance
XTmrCtr TimerCounter;

// GPIO Driver Device
XGpio device0;
XGpio device1;
XGpio device2;
XGpio device3;

// IP Tutorial  Main
int main() {
	u32 sw_data = 0, btn_data = 0;
	u32 sw_data_old = 0, btn_data_old = 0;
	u32 amp2_data = 0x8;
	u32 target_count = 0;
	u32 last_count = 0;
	u32 sw_changes = 0, btn_changes = 0;

	XStatus status;

	//Initialize timer
	status = XTmrCtr_Initialize(&TimerCounter, XPAR_TMRCTR_0_DEVICE_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization Timer failed\n\r");
		return 1;
	}

	//Make sure the timer is working
	status = XTmrCtr_SelfTest(&TimerCounter, TIMER_COUNTER_0);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization Timer failed\n\r");
		return 1;
	}

	//Configure the timer to Autoreload
	XTmrCtr_SetOptions(&TimerCounter, TIMER_COUNTER_0, XTC_AUTO_RELOAD_OPTION);
	//Initialize your timer values
	//Start your timer
	XTmrCtr_Start(&TimerCounter, TIMER_COUNTER_0);



	// Initialize the GPIO devices
	status = XGpio_Initialize(&device0, GPIO0_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_0 failed\n\r");
		return 1;
	}
	status = XGpio_Initialize(&device1, GPIO1_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_1 failed\n\r");
		return 1;
	}
	status = XGpio_Initialize(&device2, GPIO2_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_2 failed\n\r");
		return 1;
	}
	status = XGpio_Initialize(&device3, GPIO3_ID);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization GPIO_3 failed\n\r");
		return 1;
	}

	// Set directions for data ports tristates, '1' for input, '0' for output
	XGpio_SetDataDirection(&device0, GPIO0_LED_CH, GPIO0_LED_TRI);
	XGpio_SetDataDirection(&device0, GPIO0_SW_CH, GPIO0_SW_TRI);
	XGpio_SetDataDirection(&device1, GPIO1_ANODE_CH, GPIO1_ANODE_TRI);
	XGpio_SetDataDirection(&device1, GPIO1_CATHODE_CH, GPIO1_CATHODE_TRI);
	XGpio_SetDataDirection(&device2, GPIO2_BTN_CH, GPIO2_BTN_TRI);
	XGpio_SetDataDirection(&device3, GPIO3_AMP2_CH, GPIO3_AMP2_TRI);

	xil_printf("Demo initialized successfully\n\r");

	XGpio_DiscreteWrite(&device3, GPIO3_AMP2_CH, amp2_data);
    XGpio_DiscreteWrite(&device1, GPIO1_ANODE_CH, 0xE);
    XGpio_DiscreteWrite(&device1, GPIO1_CATHODE_CH, 0xff);

    play_megalovania();

	while (1) {
	    // Read switches and buttons
	    sw_data = XGpio_DiscreteRead(&device0, GPIO0_SW_CH) & 0x3; // Get switch data (2 bits)
	    btn_data = XGpio_DiscreteRead(&device2, GPIO2_BTN_CH) & 0x7; // Get button data (3 bits)

	    // Check for changes in switches and buttons
	    check_switches(&sw_data, &sw_data_old, &sw_changes);
	    check_buttons(&btn_data, &btn_data_old, &btn_changes);

	    if (sw_changes || btn_changes) {
	        // Calculate a safe `note_index`
	    	u32 note_index = (sw_data * 8) + btn_data;
	    	if (note_index >= NUM_NOTES) {
	    	    note_index = 0; // Default to OFF if out of bounds
	    	}

	        // Select the correct letter encoding for the 7-segment display
	        u8 display_value = note_display[note_index];

	        // Write the note letter to Display D
	        XGpio_DiscreteWrite(&device1, GPIO1_ANODE_CH, 0xE);
	        XGpio_DiscreteWrite(&device1, GPIO1_CATHODE_CH, display_value);

	        // Set frequency for the note
	        target_count = note_freqs[note_index];

	        // Save previous values
	        sw_data_old = sw_data;
	        btn_data_old = btn_data;

	        // Update LEDs to reflect switch state
	        update_LEDs(sw_data);
	    }


	    // Generate the sound at the correct frequency
	    update_amp2(&amp2_data, target_count, &last_count);
	}

}


// reads the value of the input switches and outputs if there were changes from last time
void check_switches(u32 *sw_data, u32 *sw_data_old, u32 *sw_changes) {
	*sw_data = XGpio_DiscreteRead(&device0, GPIO0_SW_CH);
	*sw_data &= GPIO0_SW_MASK;
	*sw_changes = 0;
	if (*sw_data != *sw_data_old) {
		// When any switch is toggled, the LED values are updated
		//  and report the state over UART.
		*sw_changes = *sw_data ^ *sw_data_old;
		*sw_data_old = *sw_data;
	}
}

// reads the value of the input switches and outputs if there were changes from last time
void check_buttons(u32 *btn_data, u32 *btn_data_old, u32 *btn_changes) {
	*btn_data = XGpio_DiscreteRead(&device2, GPIO2_BTN_CH);
	*btn_data &= GPIO2_BTN_MASK;
	*btn_changes = 0;
	if (*btn_data != *btn_data_old) {
		// When any button is toggled changes btn data
		*btn_changes = *btn_data ^ *btn_data_old;
		*btn_data_old = *btn_data;
	}
}

// writes the value of led_data to the LED pins
void update_LEDs(u32 led_data) {
	led_data = (led_data) & GPIO0_LED_MASK;
	XGpio_DiscreteWrite(&device0, GPIO0_LED_CH, led_data);
}

// if the current count is - last_count > target_count toggle the amp2 output
void update_amp2(u32 *amp2_data, u32 target_count, u32 *last_count) {
	u32 current_count = XTmrCtr_GetValue(&TimerCounter, TIMER_COUNTER_0);
	if ((current_count - *last_count) > target_count) {
		// toggling the LSB of amp2 data
		*amp2_data = ((*amp2_data & 0x01) == 0) ? (*amp2_data | 0x1) : (*amp2_data & 0xe);
		XGpio_DiscreteWrite(&device3, GPIO3_AMP2_CH, *amp2_data );
		*last_count = current_count;
	}
}

void play_note(u32 note_index, u32 duration_ms) {
    if (note_index >= NUM_NOTES) {
        return;
    }

    u32 target_count = note_freqs[note_index];
    u32 last_count = 0;
    u32 amp2_data = 0x8;

    u32 elapsed_time = 0;
    while (elapsed_time < duration_ms) {
        update_amp2(&amp2_data, target_count, &last_count);
        usleep(1000); // Sleep for 1 ms
        elapsed_time++;
    }

    XGpio_DiscreteWrite(&device3, GPIO3_AMP2_CH, 0x0);
}

void play_megalovania() {
    play_note(2, 200);
    play_note(2, 200);
    play_note(6, 200);
    play_note(13, 400);
    usleep(200000);

    play_note(12, 200);
    play_note(11, 200);
    play_note(10, 200);
    play_note(6, 200);
    play_note(11, 400);
    usleep(200000);

}

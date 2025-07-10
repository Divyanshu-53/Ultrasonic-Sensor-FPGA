# Ultrasonic Sensor Interfacing with FPGA

This project demonstrates how to interface the HC-SR04 ultrasonic distance sensor with an FPGA using Verilog HDL. The FPGA processes the echo signal to calculate the distance in centimeters.

---

## Features

- Measures distance using HC-SR04 ultrasonic sensor
- FPGA receives echo signal and calculates time-of-flight
- Displays distance on an 7-segment (optional)
- Written in Verilog HDL
- Simulatable and synthesizable design

---

## Project Structure
Ultrasonic-Sensor-FPGA/
│
├── pulse_generator.v # Sends trigger pulse to sensor
├── echo_timer.v # Measures echo pulse duration
├── distance_calc.v # Converts time to distance
├── top_module.v # Top-level integration
├── testbench.v # Verilog testbench for simulation
├── README.md # Project documentation
├── report.pdf # University report/documentation



---

## Components Used

- HC-SR04 ultrasonic sensor
- Tersaic FPGA development board DE2 Altera Cyclone II.
- 7-segment display 
- Verilog simulator - ModelSim-altera & Quartus II.



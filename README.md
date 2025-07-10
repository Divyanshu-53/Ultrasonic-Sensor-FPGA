# Ultrasonic Distance Measurement using FPGA (Verilog HDL)

This project implements a real-time ultrasonic distance measurement system using an HC-SR04 sensor and an FPGA programmed in Verilog HDL. The system is designed for the course "FPGA-Based System Design (2EC202CC23)" at Nirma University.

The project calculates the distance by measuring the duration of the echo signal and displays it on a 7-segment display.

---

## Project Highlights

- Trigger pulse generation (10 μs)
- Echo signal capture and timing
- Distance calculation using time-of-flight (ToF) formula
- Display output using 7-segment display (4 digits)
- Implemented as a Finite State Machine (FSM) in Verilog
- RTL and waveform simulations included
- FPGA implementation tested on hardware

---

## File Structure
Ultrasonic-Sensor-FPGA/
│
├── trial.v # Main Verilog module for measurement and display
├── report.pdf # University report with methodology, results, diagrams
├── README.md # Project summary and documentation
├── waveforms/ # Simulation waveforms (optional)

yaml
Copy
Edit

---

## Key Verilog Parameters

- Clock: 50 MHz
- Trigger pulse: 10 μs (500 clock cycles)
- Distance formula: `distance = (echo_count * speed_of_sound) / (2 * clock_freq)`
- 7-segment display used for visual output

---

## State Machine

The Verilog module uses a 4-state FSM:

1. **IDLE** – Waits before next trigger
2. **TRIGGER** – Sends a 10μs trigger pulse
3. **WAIT_ECHO** – Waits for rising edge of echo
4. **MEASURE** – Measures pulse width to calculate distance

---

## Simulation and Results

- RTL and TTL logic visualizations
- Waveform simulations verify trigger generation, echo capture, and distance output
- Implemented and tested on FPGA with observed range: **2 cm to 45 cm**
- Typical error: **~1 cm in 2 out of 10 measurements**

---

## Applications

- Robotics (obstacle avoidance)
- Security systems
- Industrial automation
- Smart measurement systems

---

## Author

Divyanshu Kalal  
Roll No: 23BEC053  
Institute of Technology, Nirma University  
Ahmedabad, Gujarat, India

---

## License

This project is intended for academic and educational purposes only.

# Dynamic Modelling and Simulation of the Želivka Water Conduit

This repository contains MATLAB source codes and simulation videos developed as part of the bachelor’s thesis "Dynamic Modelling and Simulation of the Želivka Water Conduit" at the Faculty of Mechanical Engineering, Czech Technical University in Prague.

The objective of this thesis was the development and implementation of a dynamic numerical model of the Želivka water conduit capable of simulating transient hydraulic phenomena occurring during various operating conditions.

## Correction to the original thesis calculations

During a subsequent review of the model, an incorrect value of the water bulk modulus was identified in the original MATLAB calculations. According to the source literature, the bulk modulus of water is

$$ K = 1.96 \times 10^9\ \mathrm{Pa}.  $$

However, the numerical value was incorrectly transferred from the source document to the calculations as

$$ K = 1.96 \times 10^{10}\ \mathrm{Pa}. $$

As a result, the calculated wave propagation speed was higher than the value typically considered for water-filled pipelines. The original simulations used

$$ a = 1796.5\ \mathrm{m/s}. $$

After correcting the bulk modulus while keeping the other pipeline parameters unchanged, the wave propagation speed was recalculated as

$$ a = 1140.33\ \mathrm{m/s}, $$

using

$$ a = \sqrt{\frac{K}{\rho\left(1+\frac{KD}{eE}\right)}}. $$

The original and corrected simulations were compared. The comparison showed that the overall dynamic behaviour of the system is only slightly affected by this correction, as the system dynamics are mainly influenced by the water exchange between the shafts. The most noticeable difference is observed in the frequency of oscillations of pressure waves in the final section of the conduit.

The corrected value of the bulk modulus and the corresponding wave propagation speed are used as the basis for further development of the model.
 
## Repository Structure

The `matlab_files` directory contains MATLAB scripts used for the simulation of four transient operating states:

- valve opening
- valve closure
- partial valve opening
- partial valve closure

The `videos` directory contains simulation outputs corresponding to the same simulation scenarios. These videos are available for download.

The simulations can be accessed via the following link: https://tabackovaandrea.github.io/Water-conduit-modelling/

## Author 

Andrea Tabačková

Faculty of Mechanical Engineering, Czech Technical University in Prague, Czech Republic





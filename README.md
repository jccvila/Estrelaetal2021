# Estrelaetal2021
FBA and CRM simulations that were used for Estrela, Sanchez-Gorostiaga, Vila and Sanchez 2021. 

Manuscript entitled Nutrient dominance governs the assembly of microbial communities in mixed nutrient environments'

Python Version 3.7
R version 4.0.3
Standard Python packages : Numpy, Pandas, Matplotlib, SciPy, Seaborn, pickle, scipy
Standard R packages: ggplot2, data.table, ggpubr,gdata,gridExtra,Metrics,operators

# FBA_Simulations

Main Dependencies: Cobrapy Version 0.17.1

Input Data Source: iJO1366.xml and iJN1463.xml where downloaded from BIGGS database.
Universe_Bacteria.xml is for convenenice as it contains some reactions that where added to iJO1366. Downloaded from https://github.com/cdanielmachado/carveme/tree/master/carveme/data/generated. Exact reaction stoichiometry can be seen in BIGGS database

To run the FBA simulations run FBA_Oxygen.ipynb jupyter notebook. 

To plot Fig4S5 results run Fig4S5.R.

# CRM_simulations

Main Dependencies: Community Simulator downloaded from https://github.com/Emergent-Behaviors-in-Biology/community-simulator
To Generate Simulation data run following scripts in Scripts Folder.
  1. Generate_Paramater_Combinations.R  : Generates list of Paramater combinations for all simulations.
  2. Generate_Matrices.py:  Generates Matrices for Fig4S4.
  3. Run Run.sh: Main simulation script. Will take a long time (2-3 days on my PC). Runs Run.py for every paramater combination,
  4. Process_Data.R : Processes Raw Simulation data to generate files used in Final plots,

All simulation data is found Data Folder. Raw simulation data is found in Data/Raw. Intermediate Files for Processing are found in Data/Temp. Final Files for plotting are in Data,

To plot Fig 4B, Fig4D Fig4S2, Fig4S3, Fig4S4 run corresponding R Scripts.  Plots found in Plot folder








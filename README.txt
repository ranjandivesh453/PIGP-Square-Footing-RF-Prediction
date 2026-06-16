# Efficient Prediction of Reduction Factors for Square Footing on Sand Layer of Finite Thickness Using Physics-Informed Genetic Programming

## OVERVIEW

This repository contains the raw dataset, processed dataset structure, and user-defined MATLAB files associated with the study:

**"Efficient Prediction of Reduction Factors for Square Footing on Sand Layer of Finite Thickness Using Physics-Informed Genetic Programming"**

The study presents a Physics-Informed Genetic Programming (PIGP) framework for predicting the reduction factor (RF) of square footings resting on sand layers of finite thickness. Unlike conventional data-driven symbolic regression approaches, the proposed framework integrates established geotechnical knowledge into the evolutionary optimization process through physics-based constraints. This enables the generation of accurate, interpretable, and physically consistent predictive equations while improving generalization capability beyond the training domain.

The materials provided in this repository are intended to facilitate reproducibility of the reported results and support future research in geotechnical engineering, symbolic regression, and physics-informed machine learning.

---

## AUTHORS

**Sumit Kumar¹, Divesh Ranjan Kumar², Arindam Guha³, Santosh Tudu⁴, Jirapon Sunkpho⁵*, Warit Wipulanusat⁶**

¹ Postdoctoral Researcher, Thammasat AI Center, College of Innovation, Thammasat University, Bangkok 10200, Thailand

² Researcher, Research Unit in Data Science and Digital Transformation, Department of Civil Engineering, Faculty of Engineering, Thammasat School of Engineering, Thammasat University, Pathum Thani, Thailand

³ Assistant Professor, Dumka Engineering College, Dumka, Jharkhand 814101, India

⁴ Assistant Professor, Department of Geology, Government Engineering College, Banka, Bihar 813102, India

⁵ Corresponding Author, Thammasat University, Thailand

⁶ Associate Professor, Research Unit in Data Science and Digital Transformation, Department of Civil Engineering, Faculty of Engineering, Thammasat School of Engineering, Thammasat University, Pathum Thani, Thailand

---

## REPOSITORY CONTENTS

### Dataset Files

**RF_data_raw.xlsx**
Contains the original raw dataset generated from numerical simulations and used in this study.

**RF_data.xlsx**
Processed dataset arranged in the format required for PIGP model training, validation, and testing.

### MATLAB Files

**PIGP_config.m**
Main configuration file containing GP settings, function set, hyperparameters, and model control parameters.

**pigp_regressmulti_fitfun.m**
Physics-informed fitness function that combines prediction accuracy and physics-based penalties.

**pigp_physics_penalty.m**
Implementation of monotonic physical constraints incorporated during model evolution.

### Output Files

**Final_PIGP_expression.txt**
Final symbolic equation obtained from the optimized PIGP model.

### Documentation

**README.txt**
Repository documentation and reproduction instructions.

---

## RAW DATASET FORMAT

The original dataset is provided in raw form with the following variables:

| Variable | Description                      |
| -------- | -------------------------------- |
| Df/B     | Foundation embedment depth ratio |
| e/B      | Load eccentricity ratio          |
| H/B      | Sand layer thickness ratio       |
| q        | Surcharge pressure               |
| RF       | Reduction factor                 |

Example:

```text
Df/B    e/B    H/B    q       RF
0       0      0.5    0       0
0       0      0.5    28.49   0.2035
0       0      0.5    56.98   0.4070
0       0      0.5    85.47   0.6105
0       0      0.5    113.96  0.8140
0       0      0.5    142.45  1.0175
0       0      0.5    170.94  1.2210
0       0      0.5    199.43  1.4245
0       0      0.5    227.92  1.6280
```

---

## INPUT VARIABLES

### Df/B

Foundation embedment depth ratio.

### e/B

Load eccentricity ratio.

### H/B

Sand layer thickness ratio.

### q

Applied surcharge pressure.

---

## OUTPUT VARIABLE

### RF

Reduction factor.

---

## DATA PREPROCESSING PROCEDURE

The raw dataset should be preprocessed before training the PIGP model.

### Step 1: Import the Raw Dataset

Load the original dataset from:

```text
RF_data_raw.xlsx
```

containing:

```text
Df/B, e/B, H/B, q, RF
```

### Step 2: Define Input and Output Variables

Input matrix:

```text
X = [Df/B, e/B, H/B, q]
```

Output vector:

```text
Y = RF
```

### Step 3: Data Normalization

Because the surcharge pressure (q) generally exhibits a significantly larger numerical range than the remaining variables, normalization is recommended prior to model training.

A commonly adopted min-max normalization approach is:

```text
X_norm = (X - Xmin)/(Xmax - Xmin)
```

where:

```text
Xmin = minimum value of each variable in training data
Xmax = maximum value of each variable in training data
```

The same normalization parameters obtained from the training dataset must be applied to the validation and testing datasets.

If output normalization is performed, the predicted RF values should be transformed back to the original scale before evaluating model performance.

### Step 4: Data Splitting

After preprocessing, the dataset may be divided as follows:

#### Option 1: Training and Testing

```text
70% Training
30% Testing
```

#### Option 2: Training, Validation, and Testing

```text
70% Training
15% Validation
15% Testing
```

A fixed random seed is recommended to ensure reproducibility.

### Step 5: Prepare Excel Sheets

The MATLAB implementation expects separate worksheets for each dataset subset.

#### Training and Testing Format

```text
Sheet: trainX
Contents: Df/B, e/B, H/B, q

Sheet: trainY
Contents: RF

Sheet: testX
Contents: Df/B, e/B, H/B, q

Sheet: testY
Contents: RF
```

#### Training, Validation, and Testing Format

```text
Sheet: trainX
Contents: Df/B, e/B, H/B, q

Sheet: trainY
Contents: RF

Sheet: valX
Contents: Df/B, e/B, H/B, q

Sheet: valY
Contents: RF

Sheet: testX
Contents: Df/B, e/B, H/B, q

Sheet: testY
Contents: RF
```

---

## PHYSICS-INFORMED CONSTRAINTS

To improve model interpretability, extrapolation capability, and consistency with geotechnical behavior, the following engineering constraints were incorporated into the fitness function:

1. RF increases with increasing Df/B.
2. RF decreases with increasing e/B.
3. RF increases with increasing H/B.
4. RF increases with increasing surcharge pressure q.

Constraint violations are penalized during model evolution through a dedicated physics-based penalty term integrated into the fitness function.

---

## SOFTWARE REQUIREMENTS

The following software packages are required:

* MATLAB R2021a or later
* GPTIPS (Genetic Programming Toolbox)
* Symbolic Math Toolbox (optional for symbolic simplification)

---

## RUNNING THE MODEL

### Step 1

Download and install GPTIPS.

### Step 2

Add GPTIPS to the MATLAB search path:

```matlab
addpath(genpath('GPTIPS'))
savepath
```

### Step 3

Place all repository files in the same MATLAB working directory.

### Step 4

Ensure that the processed dataset contains the required worksheets:

```text
trainX
trainY
testX
testY
```

or

```text
trainX
trainY
valX
valY
testX
testY
```

### Step 5

Run the PIGP model:

```matlab
gp = rungp('PIGP_config');
```

or

```matlab
PIGP_demo
```

### Step 6

Upon completion, the optimized symbolic equation will be generated and stored in:

```text
Final_PIGP_expression.txt
```

---

## REPRODUCIBILITY

To facilitate reproducibility and future research, the following materials are provided:

* Complete raw dataset
* Model configuration file
* Physics-informed fitness function
* Physics constraint implementation
* Input/output variable definitions
* Hyperparameter settings
* Final symbolic PIGP equation

The GPTIPS toolbox itself is not redistributed because it is an external open-source dependency that is publicly available from its original developers. However, all study-specific files required to reproduce the proposed PIGP model, regenerate the reported results, and obtain the final symbolic equation are provided.

---

## CITATION

If you use the dataset, code, or symbolic model in your research, please cite:

```text
Kumar, S., Kumar, D.R., Guha, A., Tudu, S.,
Sunkpho, J., and Wipulanusat, W.

Efficient Prediction of Reduction Factors for
Square Footing on Sand Layer of Finite Thickness
Using Physics-Informed Genetic Programming.
```

---

## CONTACT

For questions regarding the dataset, code, or implementation, please contact:

**Dr. Divesh Ranjan Kumar**
Email: [ranjandivesh453@gmail.com]

or

**Assoc. Prof. Warit Wipulanusat**
Email: [wwarit@engr.tu.ac.th]

---

## DISCLAIMER

The dataset, source files, and symbolic models provided in this repository are intended solely for academic and research purposes. Users are responsible for independently verifying all predictions before applying the developed models in engineering design, safety assessment, or decision-making applications.

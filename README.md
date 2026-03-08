# Optical Flow Estimation: The Horn-Schunck Method

This repository contains an implementation and evaluation of the **Horn-Schunck algorithm**, a classic global differential method for estimating optical flow. The project covers the theoretical foundation, implementation from scratch, and post-filtering techniques to improve flow robustness in video sequences.

## 1. Theoretical Foundation
The Horn-Schunck method addresses the **Aperture Problem** by introducing a global smoothness constraint. It assumes that the velocity field varies smoothly across the image. The algorithm minimizes an energy functional $E$ comprising two terms:

$$E = \iint \left[ (E_x u + E_y v + E_t)^2 + \alpha^2 (\|\nabla u\|^2 + \|\nabla v\|^2) \right] dx dy$$

* **Data Term:** Ensures the brightness constancy constraint is met.
* **Regularization Term:** Penalizes high gradients in the flow field (smoothness).

## 2. Implementation Details
The project is implemented in **MATLAB** and covers:
* **Gradient Computation:** Robust estimation of spatial ($E_x, E_y$) and temporal ($E_t$) derivatives.
* **Iterative Solver:** Implementation of the Gauss-Seidel method to solve the coupled Euler-Lagrange equations.
* **Temporal Initialization (Warm Start):** Using the flow from frame $t-1$ to initialize frame $t$, significantly accelerating convergence in video sequences.

## 3. Post-Filtering & Optimization
To handle noise and "jitter" common in raw optical flow, two filtering strategies were implemented:

### Spatial Filtering (Median Filter)
* **Method:** Applied a $3 \times 3$ median filter to the flow fields ($u, v$).
* **Goal:** Remove "salt-and-pepper" noise and outliers while preserving sharp motion boundaries (unlike Gaussian blurring).

### Temporal Filtering (Recursive)
* **Method:** Implemented a weighted average filter: $u_{filtered}(t) = \alpha \cdot u_{raw}(t) + (1-\alpha) \cdot u_{filtered}(t-1)$.
* **Goal:** Ensure temporal coherence and reduce flickering in motion estimation across frames.

## 4. Evaluation Metrics
The performance was validated using the following metrics:
* **EPE (End Point Error):** The Euclidean distance between the estimated and ground truth flow vectors.
* **AAE (Average Angular Error):** The angular deviation between the estimated and true motion direction.

## 5. Results
* **Accuracy:** The model correctly identifies motion direction (hue) and magnitude, though errors typically increase at occlusion boundaries.
* **Efficiency:** Using **Warm Start** initialization reduces the number of iterations required for convergence in traffic monitoring sequences.

---

## Usage
1. Open MATLAB.
2. Ensure all frames/sequences are in the project directory.
3. Run the main scripts for Exercise 1 (Horn-Schunck implementation) and Exercise 2 (Post-filtering analysis).

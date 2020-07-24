# Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver
## Introduction and Motivation of Sharing
This is a project modified from Stanford EE 236A Modern Optics project. Optical industry vendors typically developed their internal solvers since multilayer optical films have been extensively used in optical technology [1]. In addition to build a Matlab solver by using impedance method[4] to calculate the reflectivity/emissivity of a multilayer thin-film from s/p-polarized incident light over a range of spectrum and incident angle, the project is aimed to provide following features for researchers who are :     
- **User-friendly Data Pre-process**: automatically convert the messy csv file downloaded from refractiveinfo website [3] or sources with similar data format(e.g. repeated wavelength, seperated real and imaginary refractive indices in different rows or columns) into a compact two-column wavelength-complex-refractive-index format; merge various range of spectrum and gird size; remove NA, blank data point and duplicate points.   
- **Flexiblility**: smoothly interpolrate/extrapolate into designated wavelength grid size and range    
- **Scalability**: assuming enough computing power, the code is alble to handle arbitrary materials, number of layers, and thickness    
- **Portability**: the code can be conveniently modified and re-distributed into other programming language and platform because most work is conciesely performed and presented in 2-D matrix computation    

## Methodology & Theory
<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/Multilayer%20Structure%20Diagram.JPG" alt="Multilayer thin-film structure diagram" width="400"/>  
<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/Calculation.JPG" alt="Calculation" width="800"/> 

## Usage 
Download the materials you need from [3] or other sources as cvs format to the same directory of m.file. Then, follow the instruction in the comment of the m.file. 

## Example
**The List of Downloaded Database** 

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/databaselist.JPG" alt="Databaselist" width="500"/>

**Testing Case 1**
This is one of the optimized structure in [1]. 

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/example.png" alt="Testing case 1" width="500"/>

**Testing Case 2**
This is one of the structure in [2].

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/example2.JPG" alt="Testing case 2" width="500"/>

## Results

Case 2 results match the result on [2]. However, case 1 results are not fully matched because the author told me that he used different data set rather than [3]. The same material could show significanly different refractive index under vairous measurement condition and crystal structure. 

**Tesing Case 1**

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/testing_case_1_plot_1.jpg" alt="Testing case 1 plot 1" width="800"/>

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/testing_case_1_plot_2.jpg" alt="Testing case 1 plot 2" width="800"/>

**Testing Case 2**

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/testing_case_2_plot_1.jpg" alt="Testing case 2 plot 1" width="500"/>

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/testing_case_2_plot_2.jpg" alt="Testing case 2 plot 2" width="500"/>

<img src="https://github.com/woshipptaku/Generalized-Multilayer-Thin-film-Structure-Reflectivity-Solver/blob/master/Picture/testing_case_2_plot_3.jpg" alt="Testing case 2 plot 3" width="500"/>


## Discussion and Futher Plan
This project is useful for 1-D conceptual and numerical validation of multi-layer design. Upon demand for smaller granularity of spatial performance, the method can be extended to 3-D with optimized matrix computation. The command line user interface can be easily adjusted to graphical interface.   

## Reference
[1] Shi, Yu, et al. "Optimization of multilayer optical films with a memetic algorithm and mixed integer programming." ACS Photonics 5.3 (2017): 684-691.   
[2] Kaminski, Piotr M., Fabiana Lisco, and J. M. Walls. "Multilayer broadband antireflective coatings for more efficient thin film CdTe solar cells." IEEE Journal of Photovoltaics 4.1 (2013): 452-456.   
[3] https://refractiveindex.info/ 
[4] Haus, H.A., 1984. Waves and fields in optoelectronics. Prentice-Hall,.

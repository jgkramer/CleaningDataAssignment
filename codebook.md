
The dataset in this project are derived from smartphone sensors worn by a group of 30 subjects. 

Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 
Data signals were derived from the phones' embedded accelerometer and gyroscope, capturing 3-axial linear acceleration and angular velocity. 
The below is a list of variables in the output file. 
Note that ALL quantitative variables (i.e., all variables other than subject and activity) were normalized and bounded in the range [-1, 1].

1.  subject

Numerical identifier of the subject whose phone is providing the data for each observation.   Range is [1, 30]. 

2.  activity

Descriptive identifier of the activity that was occuring when the observation signals were made.  This variable takes six values:

(walking, walking upstairs, walking downstairs, sitting, standing, laying)

3. Mean of body acceleration signal - X direction
4. Mean of body acceleration signal - Y direction
5. Mean of body acceleration signal - Z direction

These variables are derived from the phone's accelerometer, and represent the mean of the acceleration signals of the subject's body (as separated out from the gravity component of acceleration).   Each of X direction, Y direction, and Z direction, represent the acceleration in the direction of the specified X, Y or Z axis. 

Normalized and bounded within the range [-1, 1].


6. Std. dev. of body acceleration signal - X direction  
7. Std. dev. of body acceleration signal - Y direction
8. Std. dev. of body acceleration signal - Z direction

These correspond to items 3, 4, and 5 above, and reflect the standard deviation of the body acceleration signals (as opposed to the mean).  

Normalized and bounded within the range [-1, 1].


9. Mean of gravity acceleration signal - X direction                          
10. Mean of gravity acceleration signal - Y direction                          
11. Mean of gravity acceleration signal - Z direction

These variables are derived from the phone's accelerometer, and represent the mean of the gravity component of the acceleration signal (as separated out from the subject's body's component of acceleration).   Each of X direction, Y direction, and Z direction, represent the acceleration in the direction of the specified X, Y or Z axis. 

Normalized and bounded within the range [-1, 1].


12. Std. dev. of gravity acceleration signal - X direction
13. Std. dev. of gravity acceleration signal - Y direction                     
14. Std. dev. of gravity acceleration signal - Z direction

These correspond to items 9, 10, and 11 above, and reflect the standard deviation of the gravity acceleration signals (as opposed to the mean).  

Normalized and bounded within the range [-1, 1].


15. Mean of body acceleration jerk signal - X direction
16. Mean of body acceleration jerk signal - Y direction
17. Mean of body acceleration jerk signal - Z direction

These variables are derived from the phone's accelerometer, and represent the mean of the "acceleration jerk" of the subject's body -- i.e., the derivative of acceleration with respect to time (second derivative of velocity).  Each of X direction, Y direction, and Z direction, represent the acceleration jerk in the direction of the specified X, Y or Z axis. 

Normalized and bounded within the range [-1, 1].


18. Std. dev. of body acceleration jerk signal - X direction                   
19. Std. dev. of body acceleration jerk signal - Y direction                   
20. Std. dev. of body acceleration jerk signal - Z direction     

These correspond to items 15, 16, and 17 above, and reflect the standard deviation of the body acceleration jerk signals (as opposed to the mean).  

Normalized and bounded within the range [-1, 1].


21. Mean of body gyroscope signal - X direction                        
22. Mean of body gyroscope signal - Y direction
23. Mean of body gyroscope signal - Z direction   

These variables are derived from the phone's gyroscope, and represent the mean of the angular velocity signals of the subject's body.   Each of X direction, Y direction, and Z direction, represent the angular velocity in the direction of the specified X, Y or Z axis. 

Normalized and bounded within the range [-1, 1].


24. Std. dev. of body gyroscope signal - X direction                           
25. Std. dev. of body gyroscope signal - Y direction                           
26. Std. dev. of body gyroscope signal - Z direction       

These correspond to items 21, 22, and 23 above, and reflect the standard deviation of the body angular velocity signals (as opposed to the mean).  

Normalized and bounded within the range [-1, 1].



27. Mean of body gyroscope jerk signal - X direction                           
28. Mean of body gyroscope jerk signal - Y direction                           
29. Mean of body gyroscope jerk signal - Z direction

These variables are derived from the phone's gyroscope, and represent the mean of the "angular jerk" of the subject's body -- i.e., the derivative of angular velocity with respect to time.  Each of X direction, Y direction, and Z direction, represent the angular jerk in the direction of the specified X, Y or Z axis. 

Normalized and bounded within the range [-1, 1].



30. Std. dev. of body gyroscope jerk signal - X direction                      
31. Std. dev. of body gyroscope jerk signal - Y direction
32. Std. dev. of body gyroscope jerk signal - Z direction

These correspond to items 27, 28, and 29 above, and reflect the standard deviation of the body angular jerk signals (as opposed to the mean).  

Normalized and bounded within the range [-1, 1].



33. Mean of body acceleration signal - Magnitude                               
34. Std. dev. of body acceleration signal - Magnitude

The mean and standard deviation of the magnitude of the three-dimensional body component of acceleration signals, calculated using the Euclidean norm. 

Normalized and bounded within the range [-1, 1].


35. Mean of gravity acceleration signal - Magnitude
36. Std. dev. of gravity acceleration signal - Magnitude


The mean and standard deviation of the magnitude of the three-dimensional gravity component of acceleration signals, calculated using the Euclidean norm. 

Normalized and bounded within the range [-1, 1].



37. Mean of body acceleration jerk signal - Magnitude                     
38. Std. dev. of body acceleration jerk signal - Magnitude

The mean and standard deviation of the magnitude of the body three-dimensional "acceleration jerk" signals, calculated using the Euclidean norm. 

Normalized and bounded within the range [-1, 1].


39. Mean of body gyroscope signal - Magnitude                              
40. Std. dev. of body gyroscope signal - Magnitude 

The mean and standard deviation of the magnitude of the body three-dimensional angular velocity signals, calculated using the Euclidean norm. 

Normalized and bounded within the range [-1, 1].


41. Mean of body gyroscope jerk signal - Magnitude                         
42. Std. dev. of body gyroscope jerk signal - Magnitude

The mean and standard deviation of the magnitude of the body three-dimensional angular velocity jerk signals, calculated using the Euclidean norm. 

Normalized and bounded within the range [-1, 1].




[43] "Mean of body acceleration signal - frequency domain - X direction"          
[44] "Mean of body acceleration signal - frequency domain - Y direction"          
[45] "Mean of body acceleration signal - frequency domain - Z direction"          
[46] "Std. dev. of body acceleration signal - frequency domain - X direction"     
[47] "Std. dev. of body acceleration signal - frequency domain - Y direction"     
[48] "Std. dev. of body acceleration signal - frequency domain - Z direction"     
[49] "Mean of body acceleration jerk signal - frequency domain - X direction"     
[50] "Mean of body acceleration jerk signal - frequency domain - Y direction"     
[51] "Mean of body acceleration jerk signal - frequency domain - Z direction"     
[52] "Std. dev. of body acceleration jerk signal - frequency domain - X direction"
[53] "Std. dev. of body acceleration jerk signal - frequency domain - Y direction"
[54] "Std. dev. of body acceleration jerk signal - frequency domain - Z direction"
[55] "Mean of body gyroscope signal - frequency domain - X direction"             
[56] "Mean of body gyroscope signal - frequency domain - Y direction"             
[57] "Mean of body gyroscope signal - frequency domain - Z direction"             
[58] "Std. dev. of body gyroscope signal - frequency domain - X direction"        
[59] "Std. dev. of body gyroscope signal - frequency domain - Y direction"        
[60] "Std. dev. of body gyroscope signal - frequency domain - Z direction"        
[61] "Mean of body acceleration signal - frequency domain - Magnitude"            
[62] "Std. dev. of body acceleration signal - frequency domain - Magnitude"       
[63] "Mean of body acceleration jerk signal - frequency domain - Magnitude"       
[64] "Std. dev. of body acceleration jerk signal - frequency domain - Magnitude"  
[65] "Mean of body gyroscope signal - frequency domain - Magnitude"               
[66] "Std. dev. of body gyroscope signal - frequency domain - Magnitude"          
[67] "Mean of body gyroscope jerk signal - frequency domain - Magnitude"          
[68] "Std. dev. of body gyroscope jerk signal - frequency domain - Magnitude"   



# MTInversion_1Well_TiltPlane
Test the moment inversion result using the 1 well under tilt plane condition

The program precedure:
>1. Set_Geometry_1Well_V1.m:    &set the geometry and model parameters.
>2. Gen_Ricker_Der.m
>3. TravelT_DirWav.m:           &Using the raytracing method to calculate the travel time of waves
>4. TravelTime_RefWave.m:       &According to the tilt plane, to calculate the reflect wave travel time 
>5. Cal_DirectionCosine.m:      &Calculate the direction cosine, travel distance and average velocity for the direct wave
>6. Cal_DirectionCos_Ref.m:     &Calculate the direction cosine for the reflect wave
>7. Combine_TravelTime.m:       &Combine the directive and reflective wave information
>8. Gen_Wavefield.m:            &Generate and plot the P&S-wave field
>9. Generate_Pwave.m:           &Generate the P-wave field
>10.Generate_Swave.m:           &Generate the S-wave field
>11.Inversion_CoefficientV3.m   &Generate the observe data and kernel matrix without attenuation
>12.Inversion_ObserData_Noise.m &Generate the noisy observedata for the inversion
>13.MT_Transform.m              &Transform the moment tensor to T-k parameters
>14.Plot_InvRes_4MTs_Eves.m     &Plot all the inversed moment tensors by using the P & S-wave or only using the P-wave
>15.Plot_TkErr_VariousGeometry.m&Plot the absolute inversion error of every kind of source by using P&S and P wave respectivly

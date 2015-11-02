%% 2015-11-2
% Calculate the basic parameters for the directive wave and reflective wave
function [TravelDistance,TravelTime_AllWave,Average_VpVs_DirRef,...
    DirectionCos_P,DirectionCos_S,Rho]=...
    Cal_WaveTraveling(Receivers,Shot,Vp,Vs,Layer_Z,Plane_Function)
% Using the raytracing method to calculate the travel time of directive
% wave 2015-8-27
[TraveTime_DirWav_P,TraveTime_DirWav_S,Coor_RayTrace_P,Coor_RayTrace_S,...
    SRLayers_Vp,SRLayers_Vs]=TravelT_DirWav(Receivers,Shot,Vp,Vs,Layer_Z);
% According to the tilt plane, to calculate the reflect wave travel time
[Reflection_Points,TravelDistance_RefWave,TravelTime_RefWave_P,TravelTime_RefWave_S]=...
    TravelTime_RefWave(Shot,Receivers,Plane_Function,SRLayers_Vp,SRLayers_Vs);

% Calculate the direction cosine, travel distance and average velocity for the direct wave 2015-9-15
[DirectionCos_DirP,DirectionCos_DirS,TravelDistance_DirWave,Average_VpVs]=...
    Cal_DirectionCosine(Coor_RayTrace_P,Coor_RayTrace_S,TraveTime_DirWav_P,TraveTime_DirWav_S);
% Calculate the direction cosine for the reflect wave 2015-9-15
[DirectionCos_RefP,DirectionCos_RefS]=Cal_DirectionCos_Ref(Shot,Reflection_Points);

% Combine the directive and reflective wave information 2015-9-15
% Combine the travel time
[Rho,TravelTime_AllWave,TravelTime_P,TravelTime_S]=Combine_TravelTime...
    (TraveTime_DirWav_P,TraveTime_DirWav_S,TravelTime_RefWave_P,TravelTime_RefWave_S);
% Combine the direction cosine, travel ditance
DirectionCos_P=[DirectionCos_DirP,DirectionCos_RefP];
DirectionCos_S=[DirectionCos_DirS,DirectionCos_RefS];
%
TravelDistance=[TravelDistance_DirWave,TravelDistance_RefWave];
Average_VpVs_DirRef=[Average_VpVs,Average_VpVs];

end
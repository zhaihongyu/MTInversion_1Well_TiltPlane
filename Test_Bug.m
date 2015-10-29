close all
figure

subplot(2,2,1)
hold on
plot(PWaveform_XYZ1(1,:,1),'b');
plot(PWaveform_XYZ_Q_Test(1,:,1),'r');
plot(PWaveform_XYZ1(1,:,1)-PWaveform_XYZ_Q_Test(1,:,1),'k')
subplot(2,2,2)
hold on
plot(PWaveform_XYZ1(5,:,1),'--k');
plot(PWaveform_XYZ1(15,:,1),'--b');
plot(PWaveform_XYZ1(25,:,1),'--r');

subplot(2,2,3)
hold on
plot(SWaveform_XYZ1(1,:,1),'b');
plot(SWaveform_XYZ_Q_Test(1,:,1),'r');
plot(SWaveform_XYZ1(1,:,1)-SWaveform_XYZ_Q_Test(1,:,1),'k')

subplot(2,2,4)
hold on
plot(SWaveform_XYZ1(5,:,1),'--k');
plot(SWaveform_XYZ1(15,:,1),'--b');
plot(SWaveform_XYZ1(25,:,1),'--r');
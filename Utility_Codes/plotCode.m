%this code takes in the .mat dataset files and plots the acc vs time and%
%angular velocity vs time plots%
figure
subplot 311
plot(Out(:,9),Out(:,2));
subplot 312
plot(Out(:,9),Out(:,3));
subplot 313
plot(Out(:,9),Out(:,4));
figure
subplot 311
plot(Out(:,9),Out(:,5));
subplot 312
plot(Out(:,9),Out(:,6));
subplot 313
plot(Out(:,9),Out(:,7));
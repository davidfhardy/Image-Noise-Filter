%% ECE 313 Final Project
% *TOPIC:* Image Processing
%
% *Group Members:* David Hardy, Francis Chambers
%
% *PAPER:* Switching Bilateral Filter With a Texture/Noise Detector for
% Universal Noise Removal
%% Problem Formulation
% A key probelm in image processing is removing noise while keeping the
% other characteristics of the image intact. Image noise is the distorted
% exposure and colour information that a pixel may contain. An image's
% noise can be represented Gaussian noise and impulse noise. Gaussian noise
% is the noise distributed over an image's pixel under a normal
% distribution. Impulse noise is noise which is added to some portion of
% the image's pizels and is usually caused by transmission errors. There
% have been many filters designed to detect and correct impulse noise,
% however, it would be ideal to have a universal filter that can detect and
% remove both Gaussian and impulse noise.
%% Proposed Solution
% The proposed solution is to define a switching bilateral filter (SBF)
% which can detect both Gaussian and impulse noise and filter accordingly. 
%% Data Sources
% Write shit here
%% Solutions
% First we distribute noise over the image.
I = im2double(imread('lena_image.png'));
I = rgb2gray(I);    % Convert to a grayscale image 
subplot(3,2,1),imshow(I);
title('Original Image');

% Add Salt and Pepper Noise (Impulse noise)
sp_noise = 0.01;
Isp = imnoise(I, 'salt & pepper', sp_noise);
subplot(3,2,2),imshow(Isp);
title('Salt and Pepper Noise');

% Add Gaussian Noise
%In = imnoise(Isp, 'gaussian');
In=imnoise(I,'gaussian');
subplot(3,2,3),imshow(In);
title('Gaussian and Salt & Pepper Noise');
Inew = In; % Inew will be the image where pixels are modified
%%
% Then we apply the algorithm to filter the image
% Constants
[m,n] = size(In);
N=2;
p = 35;     % any value in the range [25,40] is good (according to research paper)
Tk1 = 30;   % Tk1 and Tk2 are values provided in the research paper
Tk2 = 15;
Ic = 0;     % SBF constant --> do not confuse with image variables
for i=N+1:m-N-1
    for j=N+1:n-N-1
        % Omega0 is the set containing the pixels in the (2N+1)x(2N+1) window
        % OmegaK, K=1,2,3,4 are sets containing pixels in 4 sub windows
        [Omega0,Omega1,Omega2,Omega3,Omega4]= getWindowPoints(In,i,j,N);
        [SQMV,SQMD_B,SQMD_C] = medianVector(Omega1,Omega2,Omega3,Omega4);
        SQMR = referenceMedian(SQMV,SQMD_B,SQMD_C,p);
        [S1,S2] = noiseDetector(In(i,j),SQMR,Tk1,Tk2); 
        
        % Decide if we should filter the pixel or not
        u = In(i,j);
        if S1==1 && S2==1
            % Impulse
            Ic=SQMR;
            u = SBF(In,i,j,N,Ic);
        elseif S1==1 && S2==0
            % Gaussian noise
            Ic=In(i,j);
            u = SBF(In,i,j,N,Ic);
        end
        if u == 1
            disp([i,j]);
        end
        Inew(i,j) = u;
    end
end
figure;
subplot(1,1,1),imshow(Inew);
title('New Image');
figure;
imshow(In);
disp('done');
%%


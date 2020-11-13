%-------------------------------------------------------------------------
% Matlab Code for Arabic Text Steganography.
% by Using both Kashida and DIACRITICS methods. 
% Programmed by Dr. Abdennour Boulesnane, Email: aboulesnane@univ-constantine3.dz

%-------------------------------------------------------------------------
% Please refer to the following journal article in your research papers:
% 1- Haya Mesfer Alshahrani George R S Weir, Hybrid Arabic Text Steganography. International Journal of
% Computer and Information Technology Volume 06 – Issue 06, November 2017

% 2- Adnan Abdul-Aziz Gutub, Wael Al-Alwani, and Abdulelah Bin Mahfoodh,
% Improved Method of Arabic Text Steganography Using the Extension
% ‘Kashida’ Character. Bahria University Journal of Information & Communication Technology 
% Vol. 3, Issue 1, December 2010

% 3- Mohammed A. Aabed, Sameh M. Awaideh, Abdul-Rahman M. Elshafei and
% Adnan A. Gutub, ARABIC DIACRITICS BASED STEGANOGRAPHY. 2007 IEEE International Conference on 
% Signal Processing and Communications (ICSPC 2007), 24-27 November 2007
%-------------------------------------------------------------------------

function [index, value]=Searchforletter(mappingtable, letter)
value = false;
index = -1;

for i= 1 : length(mappingtable)
    if mappingtable{i,1}==letter
        value= true;
        index = i;
        break;
    end
end
end
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

function [covertext, originaltext] = DecodeSteganoPart2(covertext1, originaltext1,mappingtable)

bits = 6;
fatha = 1614;

[Harakatsymbol,~]  = xlsread('letters.xlsx','D1:D8');

covertext=[];
originaltext=[];

covertext1 = uint16(covertext1);
originaltext1 = uint16(originaltext1);
originaltextbits=[];

stopcount=0;
j=1;

while j <= length(covertext1)-1
    
    
    if ismember(covertext1(j),Harakatsymbol)
        if covertext1(j) == fatha
            stopcount=stopcount+1;
            originaltextbits=[originaltextbits 1];
            
            
        elseif covertext1(j) ~= fatha
            originaltextbits=[originaltextbits 0];
            
        end
    end
    
    
    j= j+1;
    if mod(length(originaltextbits),bits)==0 && stopcount~=bits
        stopcount=0;
    elseif mod(length(originaltextbits),bits)==0 && stopcount==bits
        break;
    end
end




z=1;
for i=1:bits:length(originaltextbits)
    letterbits=originaltextbits(i:z*bits);
    if sum(letterbits)==bits
        break;
    end
    letterbits= mat2str(letterbits);
    letterbits=strrep(letterbits,'[','');
    letterbits=strrep(letterbits,']','');
    
    for j =1:length(mappingtable)
        if strcmp(mappingtable{j,2}, letterbits)
            originaltext=[originaltext uint16(mappingtable{j,1})];
            break;
        end
    end
    z=z+1;
end
disp('Decode Part2')
covertext = char(covertext1)
char(originaltext)

originaltext = [originaltext1 originaltext];
originaltext = char(originaltext);
end
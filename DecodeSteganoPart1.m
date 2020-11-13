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

function [covertext, originaltext] = DecodeSteganoPart1(steganotext,mappingtable)
clc
bits = 6;
kashidadec = 1600;


ListBreaks=[46, 58, 32, 44 , 1548, 45, 95, 40, 41, 91, 93, 123, 125, 34, 47];
[~,Kashidaletters]  = xlsread('letters.xlsx','B1:B23');
[Harakatsymbol,~]  = xlsread('letters.xlsx','D1:D8');

steganotext = uint16(steganotext);
covertext=steganotext;
covertext(find(covertext==kashidadec))=[];

originaltext=[];
originaltextbits=[];


stopcount=0;
j=1;

while j <= length(steganotext)-1
    
    letter = char(steganotext(j));
    %         letter
    if steganotext(j) == 1604 % letter == Lam
        if steganotext(j+1) == 1575 % letter == alif
            j=j+1;
            continue;
        end
    end
    
    
    [index, value] =Searchforletter(Kashidaletters,   letter);
    if value == 1
        [findit, stp] = lookforbreaks(steganotext, j, ListBreaks,Harakatsymbol);
        if findit == false
            if  steganotext(j+stp+1)==kashidadec
                if steganotext(j+stp+2)==kashidadec
                    stopcount=stopcount+1;
                    
                    steganotext(j+stp+1)=[];
                    steganotext(j+stp+1)=[];
                    
                    originaltextbits=[originaltextbits 1];
                    
                else
                    stopcount=0;
                    steganotext(j+stp+1)=[];
                    originaltextbits=[originaltextbits 0];
                    
                end
            else
                originaltextbits=[originaltextbits 0];
            end
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
disp('Decode Part1')
covertext = char(covertext)
originaltext = char(originaltext)
end
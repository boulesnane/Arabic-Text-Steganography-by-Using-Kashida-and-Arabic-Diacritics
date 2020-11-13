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

function [steganotext2,mappingtable] = Harakat(covertext, secrettext,mappingtable)

bits = 6;
fatha = 1614;

steganotext2 = uint16(covertext);
[Harakatsymbol,~]  = xlsread('letters.xlsx','D1:D8');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
secrtbits=[];
for i= 1:length(secrettext)
    letter = secrettext(i);
    [index, value] =Searchforletter(mappingtable, letter);
    
    if value == 1
        
        if isempty(secrtbits)
            secrtbits= mappingtable{index,2};
        else
            secrtbits = [secrtbits ' ' mappingtable{index,2}];
        end
    else
        index = length(mappingtable)+1;
        b = de2bi( index , bits );
        b= mat2str(b);
        b=strrep(b,'[','');
        b=strrep(b,']','');
        b = flip(b);
        
        mappingtable{index,1}= letter;
        mappingtable{index,2}= b;
        mappingtable{index,3}= KashidaCost(b,bits);
        mappingtable{index,4}= 1;
        mappingtable = sortrows(mappingtable,3);
        
        if isempty(secrtbits)
            secrtbits= mappingtable{index,2};
        else
            secrtbits = [secrtbits ' ' mappingtable{index,2}];
        end
    end
    
end



finalletter = mat2str(ones(1,bits));
finalletter = strrep(finalletter,'[','');
finalletter = strrep(finalletter,']','');
secrtbits = [secrtbits ' ' finalletter];

j=1;
for i= 1:2:length(secrtbits)
    %     secrtbits(i)
    
    while j <= length(steganotext2)
        %         steganotext2(j)
        %         char(steganotext2(j))
        
        if ismember(steganotext2(j),Harakatsymbol)
            if str2num(secrtbits(i))==1
                if steganotext2(j) == fatha
                    j= j+1;
                    break;
                elseif steganotext2(j) ~= fatha
                    
                    steganotext2(j) =[];
                    continue;
                end
            elseif str2num(secrtbits(i))==0
                
                if steganotext2(j) ~= fatha
                    j= j+1;
                    break;
                elseif steganotext2(j) == fatha
                    
                    steganotext2(j) =[];
                    continue;
                end
                
                
            end
        end
        j= j+1;
    end
end

disp('Part2')
secrettext
secrtbits
steganotext2 = char(steganotext2);
end
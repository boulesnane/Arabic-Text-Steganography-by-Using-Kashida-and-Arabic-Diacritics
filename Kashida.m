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

function [steganotext1,mappingtable] = Kashida(covertext, secrettext)
clc
steganotext1= uint16(covertext);
finishingletter ='$';
bits = 6;
kashidadec = 1600;

% ListBreaks=['.', ':', ' ',',','?','-','_','(',')','[',']','{','}','"','/'];
ListBreaks=[46, 58, 32, 44 , 1548, 45, 95, 40, 41, 91, 93, 123, 125, 34, 47];


[~,Nonkashidaletters]  = xlsread('letters.xlsx','A1:A14');
[~,Kashidaletters]  = xlsread('letters.xlsx','B1:B23');
[Harakatsymbol,~]  = xlsread('letters.xlsx','D1:D8');


mappingtable= {};
for i=1:length(Nonkashidaletters)
    b = de2bi( i , bits );
    b= mat2str(b);
    b=strrep(b,'[','');
    b=strrep(b,']','');
    b = flip(b);
    
    mappingtable{i,1}= Nonkashidaletters{i};
    mappingtable{i,2}= b;
    mappingtable{i,3}= KashidaCost(b,bits);
    mappingtable{i,4}= 0;
end

for j= 1:length(Kashidaletters)
    i= i+1;
    b = de2bi( i , bits );
    b= mat2str(b);
    b=strrep(b,'[','');
    b=strrep(b,']','');
    b = flip(b);
    
    mappingtable{i,1}= Kashidaletters{j};
    mappingtable{i,2}= b;
    mappingtable{i,3}= KashidaCost(b,bits);
    mappingtable{i,4}= 0;
end

mappingtable = sortrows(mappingtable,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
secrtbits=[];
for i= 1:length(secrettext)
    letter = secrettext(i);
    [index, value] =Searchforletter(mappingtable, letter);
    
    if value == 1
        [mappingtable, newindex]=getMinKashidaCost(mappingtable, index);
        
        if isempty(secrtbits)
            secrtbits= mappingtable{newindex,2};
        else
            secrtbits = [secrtbits ' ' mappingtable{newindex,2}];
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

index = length(mappingtable)+1;
mappingtable{index,1}= finishingletter;
mappingtable{index,2}=strrep(mappingtable{1,2},'0','1');
mappingtable{index,3}= KashidaCost(mappingtable{index,2},bits);
mappingtable{index,4}= 1;
mappingtable = sortrows(mappingtable,3);

secrtbits = [secrtbits ' ' mappingtable{index,2}];

segbits=[];
j=1;
z=1;
stop = false;
i=1;
while i<=length(secrtbits)
    %     secrtbits(i)
    if i == z*2*bits+1
        z= z+1;
    end
    
    segbits = secrtbits(i:z*2*bits-1);
    segbits= strrep( segbits, ' ', '');
    
    onesbits = mappingtable{length(mappingtable),2};
    onesbits= strrep( onesbits, ' ', '');
    
    if strcmp(segbits, onesbits)
        stop = true;
        break;
    end
    
    while j <= length(steganotext1)-1
        
        letter = char(steganotext1(j));
        %         letter
        if steganotext1(j) == 1604 % letter == Lam
            if steganotext1(j+1) == 1575 || steganotext1(j+1) == 1571 % letter == alif
                j=j+1;
                continue;
            end
        end
        
        
        [index, value] =Searchforletter(Kashidaletters,   letter);
        if value == 1
            [findit, stp] = lookforbreaks(steganotext1, j, ListBreaks,Harakatsymbol);
            if findit == false
                if  str2num(secrtbits(i))==1
                    steganotext1 =[steganotext1(1:j+stp)  kashidadec kashidadec steganotext1(j+stp+1:length(steganotext1))];
                    j= j+1;
                    break;
                elseif str2num(secrtbits(i))==0
                    if str2num(secrtbits(i+2))==1
                        steganotext1 =[steganotext1(1:j+stp)  kashidadec steganotext1(j+stp+1:length(steganotext1))];
                    end
                    j= j+1;
                    break;
                end
            end
        end
        j= j+1;
    end
    i=i+2;
end

onesletters =bits;
if stop % if there is no more secret letters, we add kashida randomly
    while j <= length(steganotext1)-1
        letter = char(steganotext1(j));
        %         letter
        %         j
        
        if steganotext1(j) == 1604 % letter == Lam
            if steganotext1(j+1) == 1575 || steganotext1(j+1) == 1571 % letter == alif
                j=j+1;
                continue;
            end
        end
        
        [index, value] =Searchforletter(Kashidaletters,   letter);
        if value == 1
            [findit, stp] = lookforbreaks(steganotext1, j, ListBreaks,Harakatsymbol);
            if findit == false
                if onesletters <=bits && onesletters > 0
                    steganotext1 =[steganotext1(1:j+stp)  kashidadec kashidadec steganotext1(j+stp+1:length(steganotext1))];
                    onesletters=onesletters-1;
                    j= j+1;
                else
                    if  rand <= 0.5
                        steganotext1 =[steganotext1(1:j+stp)  kashidadec kashidadec steganotext1(j+stp+1:length(steganotext1))];
                        j= j+1;
                        
                    else
                        steganotext1 =[steganotext1(1:j+stp)  kashidadec steganotext1(j+stp+1:length(steganotext1))];
                        j= j+1;
                    end
                end
            end
        end
        j= j+1;
    end
end


disp('Part1')
secrettext
secrtbits
steganotext1 = char(steganotext1);
end
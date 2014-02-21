cd lists
str_a=importdata('emo_A.txt','\n')
len_str_a=length(str_a);
cd ..
s=char(str_a);
 a=double(s(:,2))+double(s(:,1));
w=find( (a==99) |(a==97)|(a==98) |(a==102));

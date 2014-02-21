

cd lists
str_a=importdata('emo_A.txt','\n')
len_str_a=length(str_a);
cd ..

 features_sv_a=[];
 for i= [1:len_str_a]
     features_nv= get_features( str_a(i,:) );
     features_sv_a=[features_sv_a;features_nv];
 end
 
 %--------------------------------------------------------------%
 cd lists
 
str_f=importdata('emo_F.txt','\n')
 len_str_f=length(str_f);
 cd ..

 features_sv_f=[];
 for i= [1:len_str_f]
     features_nv= get_features( str_f(i,:) )
     features_sv_f=[features_sv_f;features_nv]
 end
 
 %--------------------------------------------------------------%
 cd lists
 
 str_n=importdata('emo_N.txt','\n')
 len_str_n=length(str_n);
 cd ..
 features_sv_n=[];
 for i= [1:len_str_n]
     features_nv= get_features( str_n(i,:) )
     features_sv_n=[features_sv_n;features_nv]
 end
 
 %--------------------------------------------------------------%
 cd lists
 
 str_w=importdata('emo_W.txt','\n')
 len_str_w=length(str_w);
 cd ..

 features_sv_w=[];
 for i= [1:len_str_w]
     features_nv= get_features( str_w(i,:) )
     features_sv_w=[features_sv_w;features_nv]
 end
 %--------------------------------------------------------------%
     

cd lists
str_e=importdata('emo_E.txt','\n')
len_str_e=length(str_e);
cd ..

 features_sv_e=[];
 for i= [1:len_str_e]
     features_nv= get_features( str_e(i,:) );
     features_sv_e=[features_sv_e;features_nv];
 end
 
 %--------------------------------------------------------------%
 cd lists
 
str_l=importdata('emo_L.txt','\n')
 len_str_l=length(str_l);
 cd ..

 features_sv_l=[];
 for i= [1:len_str_l]
     features_nv= get_features( str_l(i,:) )
     features_sv_l=[features_sv_l;features_nv]
 end
 
 %--------------------------------------------------------------%
 cd lists
 
 str_t=importdata('emo_T.txt','\n')
 len_str_t=length(str_t);
 cd ..
 features_sv_t=[];
 for i= [1:len_str_t]
     features_nv= get_features( str_t(i,:) )
     features_sv_t=[features_sv_t;features_nv]
 end

cd Emo_features
dlmwrite('emo_a.dat',features_sv_a);
dlmwrite('emo_f.dat',features_sv_f);
dlmwrite('emo_n.dat',features_sv_n);
dlmwrite('emo_w.dat',features_sv_w);
dlmwrite('emo_e.dat',features_sv_e);
dlmwrite('emo_l.dat',features_sv_l);
dlmwrite('emo_t.dat',features_sv_t);
cd ..
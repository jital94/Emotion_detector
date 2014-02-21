function [ emo ] = classify_emo( testfile )
%This function takes features of a file(files) as input in form of a matrix
%and returns corresponding emotion
% ??? Error using ==> svmtrain at 470
% Unable to solve the optimization problem:
% Maximum number of iterations exceeded; increase options.MaxIter.
% To continue solving the problem with the current solution as the
% starting point, set x0 = x before calling quadprog.

        
        cd Emo_features_60
        features_sv_a=dlmread('emo_a.dat');
        features_sv_f=dlmread('emo_f.dat');
        features_sv_n=dlmread('emo_n.dat');
        features_sv_w=dlmread('emo_w.dat');
        cd ..

        len_str_a=size(features_sv_a,1);
        len_str_f=size(features_sv_f,1);
        len_str_n=size(features_sv_n,1);
        len_str_w=size(features_sv_w(1:70,:),1);

        group_a(1:len_str_a,1)=1;
        group_f(1:len_str_f,1)=2;
        group_n(1:len_str_n,1)=3;
        group_w(1:len_str_w,1)=4;


    
        svm_1_2=svmtrain(  [features_sv_a;features_sv_f]  , [group_a;group_f]  );
        svm_1_3=svmtrain(  [features_sv_a;features_sv_n]  , [group_a;group_n]  );
        svm_1_4=svmtrain(  [features_sv_a;features_sv_w(1:70,:)]  , [group_a;group_w]  );
        svm_2_3=svmtrain(  [features_sv_f;features_sv_n]  , [group_f;group_n] );
        svm_2_4=svmtrain(  [features_sv_f;features_sv_w(1:70,:)]  , [group_f;group_w]  );
        svm_3_4=svmtrain(  [features_sv_n;features_sv_w(1:70,:)]  , [group_n;group_w]  );

        label(:,1)=svmclassify( svm_1_2,testfile);
        label(:,2)=svmclassify( svm_1_3,testfile);
        label(:,3)=svmclassify( svm_1_4,testfile);
        label(:,4)=svmclassify( svm_2_3,testfile);
        label(:,5)=svmclassify( svm_2_4,testfile);
        label(:,6)=svmclassify( svm_3_4,testfile);

        for i=1:size(label,1);
            emo(i)=mode( label(i,:));
        end
end


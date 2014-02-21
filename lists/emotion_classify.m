
    clear
    cd Emo_features
    features_sv_a=dlmread('emo_a.dat');
    features_sv_f=dlmread('emo_f.dat');
    features_sv_n=dlmread('emo_n.dat');
    features_sv_w=dlmread('emo_w.dat');
    cd ..
    
    len_str_a=size(features_sv_a,1);
    len_str_f=size(features_sv_f,1);
    len_str_n=size(features_sv_n,1);
    len_str_w=size(features_sv_w,1);
    
    group_a(1:len_str_a,1)=1;
    group_f(1:len_str_f,1)=2;
    group_n(1:len_str_n,1)=3;
    group_w(1:len_str_w,1)=4;

    for k=[1:5]
        [train_a, test_a] = crossvalind('holdOut',group_a,0.3);
        [train_f, test_f] = crossvalind('holdOut',group_f,0.3);
        [train_n, test_n] = crossvalind('holdOut',group_n,0.3);
        [train_w, test_w] = crossvalind('holdOut',group_w,0.3);

%         group_a=group_a';
%         group_f=group_f';
%         group_n=group_n';
%         group_w=group_w';

        svm_1_2=svmtrain(  [features_sv_a(train_a,:);features_sv_f(train_f,:)]  , [group_a(train_a);group_f(train_f)]  );
        svm_1_3=svmtrain(  [features_sv_a(train_a,:);features_sv_n(train_n,:)]  , [group_a(train_a);group_n(train_n)]  );
        svm_1_4=svmtrain(  [features_sv_a(train_a,:);features_sv_w(train_w,:)]  , [group_a(train_a);group_w(train_w)]  );
        svm_2_3=svmtrain(  [features_sv_f(train_f,:);features_sv_n(train_n,:)]  , [group_f(train_f);group_n(train_n)] );
        svm_2_4=svmtrain(  [features_sv_f(train_f,:);features_sv_w(train_w,:)]  , [group_f(train_f);group_w(train_w)]  );
        svm_3_4=svmtrain(  [features_sv_n(train_n,:);features_sv_w(train_w,:)]  , [group_n(train_n);group_w(train_w)]  );

        incorrect=0;
        total=0;
        label=zeros( size(features_sv_a(test_a,:),1) , 6);
        label(:,1)=svmclassify( svm_1_2,features_sv_a(test_a,:));
        label(:,2)=svmclassify( svm_1_3,features_sv_a(test_a,:));
        label(:,3)=svmclassify( svm_1_4,features_sv_a(test_a,:));
        label(:,4)=svmclassify( svm_2_3,features_sv_a(test_a,:));
        label(:,5)=svmclassify( svm_2_4,features_sv_a(test_a,:));
        label(:,6)=svmclassify( svm_3_4,features_sv_a(test_a,:));

        for i=1:length(label)
        emo(i)=mode( label(i,:));
        total=total+1;
        if not(emo(i)==1)
            incorrect=incorrect+1;
        end
        end
        clear label
        perc=double(incorrect/total)

        label=zeros( size(features_sv_f(test_f,:),1) , 6);
        label(:,1)=svmclassify( svm_1_2,features_sv_f(test_f,:));
        label(:,2)=svmclassify( svm_1_3,features_sv_f(test_f,:));
        label(:,3)=svmclassify( svm_1_4,features_sv_f(test_f,:));
        label(:,4)=svmclassify( svm_2_3,features_sv_f(test_f,:));
        label(:,5)=svmclassify( svm_2_4,features_sv_f(test_f,:));
        label(:,6)=svmclassify( svm_3_4,features_sv_f(test_f,:));

        for i=1:length(label)
        emo(i)=mode( label(i,:));
        total=total+1;
        if not(emo(i)==2)
            incorrect=incorrect+1;
        end
        end
        clear label
        perc=double(incorrect/total)

        label=zeros( size(features_sv_n(test_n,:),1) , 6);
        label(:,1)=svmclassify( svm_1_2,features_sv_n(test_n,:));
        label(:,2)=svmclassify( svm_1_3,features_sv_n(test_n,:));
        label(:,3)=svmclassify( svm_1_4,features_sv_n(test_n,:));
        label(:,4)=svmclassify( svm_2_3,features_sv_n(test_n,:));
        label(:,5)=svmclassify( svm_2_4,features_sv_n(test_n,:));
        label(:,6)=svmclassify( svm_3_4,features_sv_n(test_n,:));

        for i=1:length(label)
        emo(i)=mode( label(i,:));
        total=total+1;
        if not(emo(i)==3)
            incorrect=incorrect+1;
        end
        end
        clear label
        perc=double(incorrect/total)

        label=zeros( size(features_sv_w(test_w,:),1) , 6);
        label(:,1)=svmclassify( svm_1_2,features_sv_w(test_w,:));
        label(:,2)=svmclassify( svm_1_3,features_sv_w(test_w,:));
        label(:,3)=svmclassify( svm_1_4,features_sv_w(test_w,:));
        label(:,4)=svmclassify( svm_2_3,features_sv_w(test_w,:));
        label(:,5)=svmclassify( svm_2_4,features_sv_w(test_w,:));
        label(:,6)=svmclassify( svm_3_4,features_sv_w(test_w,:));

        for i=1:length(label)
        emo(i)=mode( label(i,:));
        total=total+1;
        if not(emo(i)==4)
            incorrect=incorrect+1;
        end
        end
        clear label
        perc_f(k)=double(incorrect/total)
    end
    

    clear
    %READ FROM FILES
    cd Emo_features_60
    features_sv_a=dlmread('emo_a.dat');
    features_sv_f=dlmread('emo_f.dat');
    features_sv_n=dlmread('emo_n.dat');
    features_sv_w=dlmread('emo_w.dat');
    cd ..
    
    %STORE LENGTHS OF EACH TYPE OF FEATURE
    len_fea(1)=size(features_sv_a,1);
    len_fea(2)=size(features_sv_f,1);
    len_fea(3)=size(features_sv_n,1);
    len_fea(4)=size(features_sv_w,1);
    
    n=4;
    max_len=max(len_fea);
    emo_features=zeros(max_len,60,n);
    
    %ICORPORATE ALL FEATURES IN A 3-D ARRAY
    emo_features(1:len_fea(1),:,1)=features_sv_a;
    emo_features(1:len_fea(2),:,2)=features_sv_f;
    emo_features(1:len_fea(3),:,3)=features_sv_n;
    emo_features(1:len_fea(4),:,4)=features_sv_w;
    
    
    
    group=ones(max_len,n);
    for i=[1:n]
        group(:,i)=group(:,i)*i;
    end
    
    perc=zeros(5,n+1);
    total=zeros(5,n);
    incorrect=zeros(5,n);
    perc1=zeros(5,n+1);
    total1=zeros(5,n);
    incorrect1=zeros(5,n);
            
    
    for x=[1:1]
            %-----------------------------------------------------------------%
            %SEPERATE TEST AND TRAIN FILES

            train=logical(zeros(max_len,n));
            test=logical(zeros(max_len,n));

            for i=[1:n]
                [train_n, test_n] = crossvalind('holdOut', group(1:len_fea(i),i) ,0.3);


                train(1:len_fea(i),i)=train_n;
                test(1:len_fea(i),i)=test_n;
            end

             %-----------------------------------------------------------------%
            %CREATE SVM STRUCTS AFTER TRAINING


            k=1;
            for i=[1:n-1]
                for j=[i+1:n]
                    svm(k)=svmtrain(  [emo_features( train(:,i),:,i);emo_features(train(:,j),:,j)]  , [group(train(:,i),i);group(train(:,j),j)]  );
                    k=k+1;
                end
            end
            k=k-1;

             %-----------------------------------------------------------------%
            %CLASSIFY TEST DATA
            label=zeros( max_len , k ,n);
            for i=[1:n]
                for j=[1:k]
                    label_new=svmclassify( svm(j),emo_features( test(:,i),:,i) );
                    len_label(i)=length(label_new);
                    label(1:len_label(i),j,i)=label_new;
                end
            end

             %-----------------------------------------------------------------%
            %COMPUTE FINAL EMOTION AND RESULTS
            len1=floor(max_len*0.3);
            emo=zeros(len1,n);
            
            for i=[1:n]
                for j=[1: (len_fea(i)*0.3)]
                    emo(j,i)=mode( label(j,:,i));
                    total(x,i)=total(x,i)+1;
                    if not(emo(j,i)==i)
                        incorrect(x,i)=incorrect(x,i)+1;
                    end
                end
                perc(x,i)=double(incorrect(x,i)/total(x,i));
            end
            perc(x,n+1)=double(sum(incorrect(x,:))/sum(total(x,:)))
            %-------------------------------------------------------------%
            
           %ADABOOST

    
            aud(12,100).alpha=0;
            aud(12,100).dimension=0;
            aud(12,100).threshold=0;
            aud(12,100).direction=0;
            aud(12,100).boundary=[];
            aud(12,100).error=0;
            
            
            
            k=1;
            for i=[1:n-1]
                for j=[i+1:n]
                    [classestimate,ada_n]=adaboost('train' ,[emo_features( train(:,i),:,i);emo_features(train(:,j),:,j)]  , [group(train(:,i),i)* (-1);group(train(:,j),j)],100 );
                    iter_reached(k)=length(ada_n);
                    ada(k,1:iter_reached(k))=ada_n;
                    k=k+1;
                end
            end
            k=k-1;

             %-----------------------------------------------------------------%
            %CLASSIFY TEST DATA
            label=zeros( max_len , k ,n);
            for i=[1:n]
                for j=[1:k]
                    label_new=adaboost('apply',emo_features( test(:,i),:,i),ada(j,1:iter_reached(j)));
                    len_label(i)=length(label_new);
                    label(1:len_label(i),j,i)=label_new;
                end
            end
            
            
            %-----------------------------------------------------------------%
          for h=[1:n]
                k=1;
                for i=[1:n-1]
                    for j=[i+1:n]
                        ae=find(label(:,k,h)==1);
                        label(ae,k,h)=j;
                        de=find(label(:,k,h)==-1);
                        label(de,k,h)=i;
                        clear de ae;
                        k=k+1;
                    end
                end
          end     
          %-----------------------------------------------------------------%
            
            %COMPUTE FINAL EMOTION AND RESULTS
            len1=floor(max_len*0.3);
            emo=zeros(len1,n);
            
            for i=[1:n]
                for j=[1: (len_fea(i)*0.3)]
                    emo(j,i)=mode( label(j,:,i));
                    total1(1,i)=total1(1,i)+1;
                    if not(emo(j,i)==i)
                        incorrect1(1,i)=incorrect1(1,i)+1;
                    end
                end
                perc1(1,i)=double(incorrect1(1,i)/total1(1,i));
            end
            perc1(1,n+1)=double(sum(incorrect1(1,:))/sum(total1(1,:)))
            
    
    end
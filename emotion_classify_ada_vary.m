
   
    clear
    %READ FROM FILES
    cd Emo_features_75
    features_sv_a=dlmread('emo_a.dat');
    features_sv_f=dlmread('emo_f.dat');
    features_sv_n=dlmread('emo_n.dat');
    features_sv_w=dlmread('emo_w.dat');
    cd ..
    s=find(features_sv_a(:,1)~=0);
    features_sv_a=features_sv_a(s,:);
    s=find(features_sv_f(:,1)~=0);
    features_sv_f=features_sv_f(s,:);
    s=find(features_sv_n(:,1)~=0);
    features_sv_n=features_sv_n(s,:);
    s=find(features_sv_a(:,1)~=0);
    features_sv_w=features_sv_w(s,:);
    
    
    
    
    
    %STORE LENGTHS OF EACH TYPE OF FEATURE
    len_fea(1)=size(features_sv_a,1);
    len_fea(2)=size(features_sv_f,1);
    len_fea(3)=size(features_sv_n,1);
    len_fea(4)=size(features_sv_w,1);
    
    n=4;
    max_len=max(len_fea);
    emo_features=zeros(max_len,75,n);
    
    %INCORPORATE ALL FEATURES IN A 3-D ARRAY
    emo_features(1:len_fea(1),:,1)=features_sv_a;
    emo_features(1:len_fea(2),:,2)=features_sv_f;
    emo_features(1:len_fea(3),:,3)=features_sv_n;
    emo_features(1:len_fea(4),:,4)=features_sv_w;
    
    
    
    group=ones(max_len,n);
    
    perc=zeros(100,n+1);
    total=zeros(100,n);
    incorrect=zeros(100,n);
            
    %SEPERATE TEST AND TRAIN FILES

            train=logical(zeros(max_len,n));
            test=logical(zeros(max_len,n));

            for i=[1:n]
                [train_n, test_n] = crossvalind('holdOut', group(1:len_fea(i),i) ,0.3);


                train(1:len_fea(i),i)=train_n;
                test(1:len_fea(i),i)=test_n;
            end

     itt=100
      %-----------------------------------------------------------------%
            
             %-----------------------------------------------------------------%
            %CREATE ada STRUCTS AFTER TRAINING
            aud(12,itt).alpha=0;
            aud(12,itt).dimension=0;
            aud(12,itt).threshold=0;
            aud(12,itt).direction=0;
            aud(12,itt).boundary=[];
            aud(12,itt).error=0;
            
            
            
            k=1;
            for i=[1:n-1]
                for j=[i+1:n]
                    [classestimate,ada_n]=adaboost('train' ,[emo_features( train(:,i),:,i);emo_features(train(:,j),:,j)]  , [group(train(:,i),i)* (-1);group(train(:,j),j)],itt );
                    iter_reached(k)=length(ada_n);
                    ada(k,1:iter_reached(k))=ada_n;
                    k=k+1;
                end
            end
            k=k-1;

            
            
 for x=[1:itt]
      
             %-----------------------------------------------------------------%
            %CLASSIFY TEST DATA
            label=zeros( max_len , k ,n);
            for i=[1:n]
                for j=[1:k]
                    label_new=adaboost('apply',emo_features( test(:,i),:,i),ada(j,1:min(x,iter_reached(j))));
                    len_label(i)=length(label_new);
                    label(1:len_label(i),j,i)=label_new;
                end
            end
            
            
            %-----------------------------------------------------------------%
          for h=[1:n]
                t=1;
                for i=[1:n-1]
                    for j=[i+1:n]
                        ae=find(label(:,t,h)==1);
                        label(ae,t,h)=j+4;
                        de=find(label(:,t,h)==-1);
                        label(de,t,h)=i+4;
                        clear de ae;
                        t=t+1;
                    end
                end
          end  
          label=label-4;
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
            perc(x,n+1)=double(sum(incorrect(x,:))/sum(total(x,:)));
            
 end
 plot(   ( 1-perc(:,5) )*100)
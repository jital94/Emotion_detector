function [ features_new  ] = get_features( filename )

                cd MIRtoolbox1.4.1
                cd MIRToolbox
                s=cd;
                path(s,path);
                cd ..;
                cd AuditoryToolbox;
                s=cd;
                path(s,path);
                cd ..;
                cd ..;
                
                cd wav
                aud = miraudio(filename,'label',0);
  %%-------------------------------PITCH(5)-------------------------------%
                pitch= mirgetdata(mirpitch(aud,'frame',.05,.05,'mono'));
                energy=mirgetdata(mirrms(aud,'frame',.05,.05));

                pitch_voiced=[];
                len=length(energy);
                unvoice_sum=0;
                unvoice_no=0;
                voice_no=0;
                voice_sum=0;
                sr_total=0;
                sr_current=0;
                sr_no=0;
                x=1;
                for k=[1:len]
                if( energy(k) < (mean(energy)+std(energy)) )
                    unvoice_sum=unvoice_sum+energy(k);
                    unvoice_no=unvoice_no + 1;
                    sr_total=sr_total+sr_current;
                    if(sr_current>0)
                        sr_no=sr_no + 1;
                    end
                    sr_current=0;

                else
                        pitch_voice(x)=pitch(k);
                        x=x+1;
                        voice_sum=voice_sum+energy(k);
                        voice_no=voice_no + 1;
                        sr_current=sr_current+0.05;
                 end
                 end

                pitch = pitch(isfinite(pitch));
                pitch = pitch(abs(pitch-mean(pitch)) <= 2*std(pitch));
                features_new=[];
                features_new=[features_new,mean(pitch)];
                features_new=[features_new,std(pitch)];
                features_new=[features_new,max(pitch)];
                features_new=[features_new,min(pitch)];
                features_new=[features_new,median(pitch)];
    
%-----------------ENERGY AND VOICING(14)-----------------------------------%                
                fr_unv=0;
                fr_v=0;
                dur_unv=0;
                dur_v=0;
                dur_seg_unv=[];
                dur_seg_v=[];
                for k=[1:len]
                    if( energy(k) < (0.01*max(energy)) )
                        dur_unv=dur_unv+0.05;
                        fr_unv=fr_unv + 1;
                        if(dur_v>0)
                            dur_seg_v=[ dur_seg_v,dur_v];
                        end
                        dur_v=0;

                    else
                        dur_v=dur_v+0.05;
                        fr_v=fr_v + 1;
                        if(dur_unv>0)
                            dur_seg_unv=[ dur_seg_unv,dur_unv];
                        end
                        dur_unv=0;

                    end
                end
                
                
                features_new=[features_new,unvoice_sum/unvoice_no];
                features_new=[features_new,voice_sum/voice_no];
                features_new=[features_new,sr_no/sr_total];
                
%                 features_new=[features_new,std(dur_seg_v)];
%                 features_new=[features_new,max(dur_seg_v)];
%                 features_new=[features_new,min(dur_seg_v)];
%                 features_new=[features_new,mean(dur_seg_v)];
%                 
%                 features_new=[features_new,std(dur_seg_unv)];
%                 features_new=[features_new,max(dur_seg_unv)];
%                 features_new=[features_new,min(dur_seg_unv)];
%                 features_new=[features_new,mean(dur_seg_unv)];
%                 
%                 features_new=[features_new,sum(dur_seg_v)/sum(dur_seg_unv)];
%                 features_new=[features_new,fr_v/len];
%                 features_new=[features_new,mean(dur_seg_v)/mean(dur_seg_unv)];
% %-------------------------SHIMMER AND JITTER(4)-----------------------------%%
                peak=mirpeaks(aud,'order','Abscissa');
                
                s=get(peak,'PeakPos');
                a=s{1};
                s=a{1};
                peakpos=s{1};
                clear s a;
                s=get(peak,'PeakVal');
                a=s{1};
                s=a{1};
                peakval=s{1};
                clear s a;
                len=length(peakpos);
                for i=[1:len-1]
                    period(i)=peakpos(i+1)-peakpos(i);
                end
                diff_amp=0;
                for i=[1:len-1]
                    diff_amp=diff_amp+abs(peakval(i+1)-peakval(i));
                end
                diff_per=0;
                for i=[1:len-2]
                    diff_per=diff_per+abs(period(i+1)-period(i));
                end
                
%                 features_new=[features_new,mean(period)];
%                 features_new=[features_new,std(period)];
%                 features_new=[features_new,diff_amp/mean(peakval)];
%                 features_new=[features_new,diff_per/mean(period)];
                
                
%%-----------------------------MFCC---------------------------------------%%               
                mean_mfcc=[1:12];
                mfcc=mirgetdata(mirmfcc(aud,'frame',.05,.05));
                for j=1:12
                features_new=[features_new,std(mfcc(j,:))];
                features_new=[features_new,max(mfcc(j,:))];
                features_new=[features_new,min(mfcc(j,:))];
                a=mean(mfcc(j,:));
                features_new=[features_new,a];
                mean_mfcc(j)=a;
                end

%                 mean_mfcc_d1=[1:12];
%                 mfccd=mirgetdata(mirmfcc(aud,'frame',.05,.05,'delta',1));
%                 for j=1:12
%                 features_new=[features_new,std(mfccd(j,:))];
%                 features_new=[features_new,max(mfccd(j,:))];
%                 features_new=[features_new,min(mfccd(j,:))];
%                 a=mean(mfccd(j,:));
%                 features_new=[features_new,a];
%                 mean_mfcc_d1(j)=a;
%                 end

                features_new=[features_new,std(mean_mfcc)];
                features_new=[features_new,max(mean_mfcc)];
                features_new=[features_new,min(mean_mfcc)];
                features_new=[features_new,mean(mean_mfcc)];

%                 features_new=[features_new,std(mean_mfcc_d1)];
%                 features_new=[features_new,max(mean_mfcc_d1)];
%                 features_new=[features_new,min(mean_mfcc_d1)];
%                 features_new=[features_new,mean(mean_mfcc_d1)];

                cd ..

end


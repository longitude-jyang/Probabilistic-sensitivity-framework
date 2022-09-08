% calSen_moments  calculates the moments of the response and its
% sensitivities

function  rEy = calSen_moments (y,xS,N_m)

 [Ns,N_QoI] = size(y); % Ns is number of samples
 [~,N_UPar] = size(xS.samp);


 rEy = zeros(N_UPar*2,N_QoI*N_m);

 nn = 0; 
 for ii = 1 : N_QoI
     
    for jj = 1 : N_m  
        
        nn = nn + 1;

        if jj == 1
            u = y(:,ii);
        else
%             u = [y(:,ii) - mean(y(:,ii))].^jj; 
            u = (y(:,ii)).^jj; 
        end

        Ey  = mean(u);
        Eyb = zeros(2*N_UPar,1);
    
        for kk = 1 : N_UPar
            Eyb (kk) = mean(u.*xS.senA(:,kk),1,'omitnan');  
            Eyb (kk + N_UPar) = mean(u.*xS.senB(:,kk),1,'omitnan'); 
        end 
    
        rEy(:,nn) = Eyb./Ey;   
    end
 end


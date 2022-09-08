function paraRank = parRank(nPar,V_e,D_e)


s = zeros(nPar,nPar*2);

for ii = 1 : nPar*2
    for jj = 1 : nPar
        
        s(jj,ii)=V_e(jj,ii).^2 + V_e(jj+nPar,ii).^2;

    end
end

% paraRank = s*diag(D_e)/sum(diag(D_e)); % weighted sum of contributions 

paraRank = s*diag(D_e);

paraRank = paraRank/sum(paraRank);

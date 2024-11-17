function  [U,V]=GOCNMF(X,W,Options)
  
 %..............................................
        [M, N]= size(X);
         if ~isempty(W)
            D= diag(sum(W,1));
            LV= D - W;
            LV_P = (abs(LV) + LV)/2;
            LV_N = (abs(LV) - LV)/2;
         end
        
     
      C = zeros(Options.gndSmpNum, Options.KClass);
        for i =1:Options.gndSmpNum
             C(i,Options.Smpgnd(i)) = 1;
        end
      
        U = abs(randn(M, Options.KClass));
        V = abs(randn(N, Options.KClass));
 
   
       for iters = 1:Options.maxIter
          V(1:Options.gndSmpNum,:)=C;
          U =U.*(X*V)./(U*V'*V+eps);
          V =V.*((X'*U+Options.alpha*LV_N*V)./(V*U'*U+Options.alpha*LV_P*V+eps));%     
 
         
       
        end

end
       
    
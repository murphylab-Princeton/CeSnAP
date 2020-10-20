function [A] = f_closed_area(C)
      n = max(size(C));     
if n <= 2
   A = 0;
else
    [nx,ny] = size(C);
    if nx < ny   
        C = C';  
    end
    if C(n,:) ~= C(1,:)  
            C2 = zeros(nx+1,ny); 
     C2(1:n,:) = C(1:n,:);      
     C2(n+1,:) = C(1,:);          
             C = C2;
    end    
    x = C(:,1);  
    y = C(:,2);  
    for i = 1:n-1
        a(i) = 0.5*((x(i+1) + x(i))*(y(i+1) - y(i))) - 0.5*((y(i+1) + y(i))*(x(i+1) - x(i)));  
    end
    A = 0.5*sum(a);
    
end
end
function [B] = reSetLabels( A, originalLabels, newLabels )
%reSetLabels Replace A's element elementwise as originalLabels-->newLabels
    % orgLabMin = min(originalLabels(:));
    % newLabMin = min(newLabels(:));
    % newLabMax = max(newLabels(:));
    orgLabMax = max(originalLabels(:));
    newLabels = newLabels + orgLabMax;%make sure that originalLabels are all different than newLabels
    
    B  = changem_vectorized(A, newLabels, originalLabels);
    
    B = B - orgLabMax;%make sure to take the labels to their proper values
    B(B<0) = 0;
    %difResult = testWithOther(A, originalLabels, newLabels);
end

function difResult = testWithOther(A, originalLabels, newLabels) %#ok<DEFNU>
    tic;
    B1  = changem_vectorized(A,newLabels,originalLabels);
    b1_t = toc;
    
    tic;
    B2  = changem_ismember(A,newLabels,originalLabels);
    b2_t = toc;
    
    disp(['b1(' num2str(b1_t) '),b2(' num2str(b2_t) ')']);
    if b1_t<b2_t
        difResult = 1;
        disp('b1 is better');
    else
        difResult = 2;
        disp('b2 is better');
    end
    
    assert(sum(sum(B1 - B2))==0,'must match')
end

function B1  = changem_vectorized(A,newval,oldval)
    %http://stackoverflow.com/questions/13812656/elegant-vectorized-version-of-changem-substitute-values-matlab/28263828#28263828
    %6 votes on 2016-12-14
    %better faster
    B1 = A;
    [valid,id] = max(bsxfun(@eq,A(:),oldval(:).'),[],2); %//'
    B1(valid) = newval(id(valid));
end

function B2  = changem_ismember(A,newval,oldval)
    %http://stackoverflow.com/questions/13812656/elegant-vectorized-version-of-changem-substitute-values-matlab/28263828#28263828
    %10 votes on 2016-12-14
    B2 = A;
    [a,b] = ismember(A,oldval);
    B2(a) = newval(b(a));
end
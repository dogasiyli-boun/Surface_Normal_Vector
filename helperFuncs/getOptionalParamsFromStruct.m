function retVal = getOptionalParamsFromStruct(structVar, fieldName, defaultValue, returnDefaultIfEmpty) %#ok<INUSL>
    if ~exist('returnDefaultIfEmpty','var') || isempty(returnDefaultIfEmpty)
       returnDefaultIfEmpty = false;
    end
    try
        %try to get the value from the struct
        eval(['retVal = {structVar.' fieldName '};']);
        %it will generate error if not exists and return default value
        if returnDefaultIfEmpty && isempty(retVal) %#ok<NODEF>
            retVal = defaultValue;
        elseif returnDefaultIfEmpty && ischar(retVal) && strcmp(retVal,'')
            retVal = defaultValue;
        elseif iscell(retVal) && length(retVal)==1
            retVal = retVal{1,1};
        end
    catch
        retVal = defaultValue;
    end
end
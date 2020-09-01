function [fieldValue] = getStructField(optionalMethodParamsStruct,fieldName,defaultFieldValue)
    if nargin<3 || ~exist('defaultFieldValue','var')
        defaultFieldValue = [];
    end
    try
        if isfield(optionalMethodParamsStruct, fieldName)
            fieldValue = optionalMethodParamsStruct.(fieldName);
        else
            fieldValue = defaultFieldValue;
        end
    catch
        fieldValue = defaultFieldValue;
    end
end
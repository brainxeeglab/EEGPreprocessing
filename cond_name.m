function res=cond_name(t,u,v)

if strcmpi(t,'TAR1') && strcmpi(u,'MSK1') && strcmpi(v,'PROL')
    res='OV1L';
elseif strcmpi(t,'TAR2') && strcmpi(u,'MSK1') && strcmpi(v,'PROL')
    res='OV2L';
elseif strcmpi(t,'TAR3') && strcmpi(u,'MSK1') && strcmpi(v,'PROL')
    res='OV3L';    
elseif strcmpi(t,'TAR4') && strcmpi(u,'MSK1') && strcmpi(v,'PROL')
    res='OV4L';  
elseif strcmpi(t,'TAR5') && strcmpi(u,'MSK1') && strcmpi(v,'PROL')
    res='OV5L';  
elseif strcmpi(t,'TAR6') && strcmpi(u,'MSK1') && strcmpi(v,'PROL')
    res='OV6L'; 
elseif strcmpi(t,'TAR1') && strcmpi(u,'MSK1') && strcmpi(v,'PROR')
    res='OV1R';
elseif strcmpi(t,'TAR2') && strcmpi(u,'MSK1') && strcmpi(v,'PROR')
    res='OV2R';
elseif strcmpi(t,'TAR3') && strcmpi(u,'MSK1') && strcmpi(v,'PROR')
    res='OV3R';    
elseif strcmpi(t,'TAR4') && strcmpi(u,'MSK1') && strcmpi(v,'PROR')
    res='OV4R';  
elseif strcmpi(t,'TAR5') && strcmpi(u,'MSK1') && strcmpi(v,'PROR')
    res='OV5R';  
elseif strcmpi(t,'TAR6') && strcmpi(u,'MSK1') && strcmpi(v,'PROR')
    res='OV6R';  
elseif strcmpi(t,'TAR1') && strcmpi(u,'MSK2') && strcmpi(v,'PROL')
    res='OI1L';
elseif strcmpi(t,'TAR2') && strcmpi(u,'MSK2') && strcmpi(v,'PROL')
    res='OI2L';
elseif strcmpi(t,'TAR3') && strcmpi(u,'MSK2') && strcmpi(v,'PROL')
    res='OI3L';    
elseif strcmpi(t,'TAR4') && strcmpi(u,'MSK2') && strcmpi(v,'PROL')
    res='OI4L';  
elseif strcmpi(t,'TAR5') && strcmpi(u,'MSK2') && strcmpi(v,'PROL')
    res='OI5L';  
elseif strcmpi(t,'TAR6') && strcmpi(u,'MSK2') && strcmpi(v,'PROL')
    res='OI6L'; 
elseif strcmpi(t,'TAR1') && strcmpi(u,'MSK2') && strcmpi(v,'PROR')
    res='OI1R';
elseif strcmpi(t,'TAR2') && strcmpi(u,'MSK2') && strcmpi(v,'PROR')
    res='OI2R';
elseif strcmpi(t,'TAR3') && strcmpi(u,'MSK2') && strcmpi(v,'PROR')
    res='OI3R';    
elseif strcmpi(t,'TAR4') && strcmpi(u,'MSK2') && strcmpi(v,'PROR')
    res='OI4R'; 
elseif strcmpi(t,'TAR5') && strcmpi(u,'MSK2') && strcmpi(v,'PROR')
    res='OI5R';  
elseif strcmpi(t,'TAR6') && strcmpi(u,'MSK2') && strcmpi(v,'PROR')
    res='OI6R';  
elseif strcmpi(t,'TAR1') && strcmpi(u,'MSK3') && strcmpi(v,'PROL')
    res='SS1L';
elseif strcmpi(t,'TAR2') && strcmpi(u,'MSK3') && strcmpi(v,'PROL')
    res='SS2L';
elseif strcmpi(t,'TAR3') && strcmpi(u,'MSK3') && strcmpi(v,'PROL')
    res='SS3L';    
elseif strcmpi(t,'TAR4') && strcmpi(u,'MSK3') && strcmpi(v,'PROL')
    res='SS4L';  
elseif strcmpi(t,'TAR5') && strcmpi(u,'MSK3') && strcmpi(v,'PROL')
    res='SS5L';  
elseif strcmpi(t,'TAR6') && strcmpi(u,'MSK3') && strcmpi(v,'PROL')
    res='SS6L'; 
elseif strcmpi(t,'TAR1') && strcmpi(u,'MSK3') && strcmpi(v,'PROR')
    res='SS1R';
elseif strcmpi(t,'TAR2') && strcmpi(u,'MSK3') && strcmpi(v,'PROR')
    res='SS2R';
elseif strcmpi(t,'TAR3') && strcmpi(u,'MSK3') && strcmpi(v,'PROR')
    res='SS3R';    
elseif strcmpi(t,'TAR4') && strcmpi(u,'MSK3') && strcmpi(v,'PROR')
    res='SS4R';  
elseif strcmpi(t,'TAR5') && strcmpi(u,'MSK3') && strcmpi(v,'PROR')
    res='SS5R';  
elseif strcmpi(t,'TAR6') && strcmpi(u,'MSK3') && strcmpi(v,'PROR')
    res='SS6R'; 
end
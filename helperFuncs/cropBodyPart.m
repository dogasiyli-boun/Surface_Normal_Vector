function curCrpAr = cropBodyPart(im, wh_begins, wh_lengths)
    %wha = cropArea.LH_big(i,1:2) - width height beginnings [width height]
    %whl = cropArea.LH_big(i,3:4) - width height length [width height]
    im_hyrow_size = size(im,1);
    im_wxcol_size = size(im,2);
    
    %crop can be max of image sizes on both direction
    imCrop_hyRow_size = min(wh_lengths(2),im_hyrow_size);
    imCrop_wxCol_size = min(wh_lengths(1),im_wxcol_size);
    
    wxcol_begin = max(wh_begins(1), 1);%start at least from beginning of image in X-width;
    wxcol_end = floor(wh_begins(1)+imCrop_wxCol_size);%for double precision apply floor on start X-width
    if (wxcol_end>im_wxcol_size)
        wxcol_end = im_wxcol_size;%make end same as image
        wxcol_begin = im_wxcol_size - imCrop_wxCol_size + 1;%
    end
    %wxcol_end = min(wxcol_end, im_wxcol_size);%wxt can not be bigger than end of image on X-width
    %changed this to shift block instead of cropping
    wxcols = wxcol_begin:wxcol_end;
    
    hyrow_begin = max(wh_begins(2), 1);%start at least from beginning of image in Y-height;
    hyrow_end = floor(wh_begins(2)+imCrop_hyRow_size);
    if (hyrow_end>im_hyrow_size)
        hyrow_end = im_hyrow_size;%make end same as image
        hyrow_begin = im_hyrow_size - imCrop_hyRow_size + 1;%
    end
    %hyrow_end = min(hyrow_end, im_hyrow_size);
    %changed this to shift block instead of cropping
    hyrows = hyrow_begin:hyrow_end;
    curCrpAr = squeeze(im(hyrows,wxcols,:));
end
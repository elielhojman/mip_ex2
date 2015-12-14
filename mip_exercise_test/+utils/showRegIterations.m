function tf = showRegIterations(fixed,moving,scoringHandle,transformationType,axis)
    global glob;
    glob.fixed = fixed;
    glob.axialFixed = getAxialSlice(glob.fixed.img, fixed.ref, 0, affine3d(eye(4)));
    glob.moving = moving;
    glob.axis = axis(:);
    switch transformationType
        case 'shift'
            glob.shift = true;
        case 'rotation'
            glob.shift = false;
        otherwise
            error(['bad transformationType ' transformationType]);
    end
%     fun = @(dof) -scoringHandle(fixed.img, transform(moving.img,moving.ref,dof2tf(dof)));
    fun = @(s) -scoringHandle(fixed.img, transform(moving.img,moving.ref,dof2tf(s)));
    finalDof = fminbnd(fun ,-90,90,optimset('PlotFcn',@optimplotimg,'TolFun',1e-3,'TolX',1e-2));
    tf = dof2tf(finalDof);

end

function tf = dof2tf(dof)
%     if norm(dof(1:3)) < 1e-3
%         rotAxis = [0;0;1];
%         rot_deg = 0;
%     else
%         rotAxis = dof(1:3)/norm(dof(1:3));
%         rot_deg = norm(dof(1:3));
%     end
    global glob;
    if glob.shift

        rotAxis = [0;0;1];
        rot_deg = 0;
        shift_mm = dof*glob.axis;
    else
        shift_mm = [0 0 0];
        rotAxis = glob.axis;
        rot_deg = dof;
    end

    tf = utils.getAffine3d(rotAxis,rot_deg,shift_mm);
end

function out = transform(img,ref,tf)
    out = imwarp(img,ref,tf,'Nearest','OutputView',ref);
end

function stop = optimplotimg(x,optimValues,state,varargin)
    global glob;

    stop = false;
    switch state
        case 'init'
%             f = figure;
        case 'iter'
%             figure(f);
            tf = dof2tf(x);
            [axialMoving,ref2d] = getAxialSlice(glob.moving.img, glob.moving.ref, 0, tf);
            temp = glob.axialFixed;
            temp(edge(axialMoving,'Canny')) = 0;
            imshowpair(glob.axialFixed,ref2d,temp,ref2d,'falsecolor','Scaling','independent','ColorChannels',[1 2 1 ]);
            
            axis equal xy tight off;
            ylabel(sprintf('Iter %d; Current score %.3f',optimValues.iteration, -optimValues.fval));
            if glob.shift
                tformStr = 'Current value of shift = %.2f mm';
            else
                tformStr = 'Current value of rotation = %.2f deg';
            end
            title(sprintf(tformStr,x));
            drawnow;
    end

end


function [zSlice, slice2DRef] =  getAxialSlice(img, ref, zVal, correctiveTform)


    slice3DRef = imref3d( [ref.ImageSize(1:2) 2], ...
        ref.XWorldLimits, ...
        ref.YWorldLimits, ...
        [zVal zVal+2*ref.PixelExtentInWorldZ]);
    slice2DRef = imref2d([ref.ImageSize(1) ref.ImageSize(2)],...
        slice3DRef.YWorldLimits, ...
        slice3DRef.XWorldLimits);

        
    zSlice = imwarp(img, ref, ...
        correctiveTform, 'OutputView', slice3DRef,'FillValues',double(min(img(:))));
    zSlice = zSlice(:,:,1);
end


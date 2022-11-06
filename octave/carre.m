function y=carre
    y = zeros(512,1) ;

    for k=0 :3,
        y((64*2*k+1) :64*(2*k+1))=1 ;
    end
end

% title("fonction carree");
% plot(carre(x))

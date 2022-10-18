x = zeros(512,1) ;

for k=0 :3,
    x((64*2*k+1) :64*(2*k+1))=1 ;
end

title("fonction carree");
plot(x)

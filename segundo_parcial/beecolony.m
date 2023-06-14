%abc example
%artificial bee colony

function  ABC()

    %function eggholder

    func='((-1)*(y+47)*(sin(sqrt(abs(y*(x/2)+47))))) - (x*sin(sqrt(abs(x-(y+47)))))';

    f=vectorize(inline(func));

    range=[-512 512 -512 512];
    Range=range(2)-range(1);

    %initial parameter
    d=2;
     np=100;

    food_source=round(np/2);
    gmax=150; %maximun number generations
    limit= 15;
    pop=(rand(food_source,d)* Range)+range(1);
    ndiv=100;
    dx=Range/ndiv;
    dy=dx;
    [x,y]=meshgrid(range(1):dx:range(2),range(3):dy:range(4));
    z=f(x,y);
    figure,surfc(x,y,z);
    figure,contour(x,y,z,15);
    for ii=1:food_source
        valfit(ii)=f(pop(ii,1),pop(ii,2));
        fitness(ii)=calculatefitness(valfit(ii));
    end 
    figure,contour(x,y,z,15);hold on;
    plot(pop(:,1),pop(:,2),'b.','markersize',15);
    drawnow; 
    hold on;
    test=zeros(1,food_source);
    bestInd=find(valfit==min(valfit));
    bestInd=bestInd(end);
    globalmin=valfit(bestInd);
    globalparams=pop(bestInd,:);
    g=0;

    while((g< gmax))
        for i=1:(food_source)
            param2change=fix(rand*d)+1;
            neighbor=fix(rand*(food_source))+1;
            while (neighbor==i)
                neighbor=fix(rand*(food_source))+1;
            end
            solutions=pop(i,:);
            solutions(param2change)=pop(i,param2change)+(pop(i,param2change)-pop(neighbor,param2change))*(rand-0.5)*2;
            ind=find(solutions<range(1));
            solutions(ind)=range(1);
            ind=find(solutions>range(2));
            solutions(ind)=range(2);
            valfitsol=f(solutions(1),solutions(2));
            fitnesssol=calculatefitness(valfitsol);
            if(fitnesssol>fitness(i))
                pop(i,:)=solutions;
                fitness(i)=fitnesssol;
                valfit(i)=valfitsol;
                test(i)=0;
            else
                test(i)=test(i)+1;
            end
        end
        %Ffitness values
        probab=(0.9 * fitness./max(fitness)+0.1);
        i=1;
        t=0;
        while(t<food_source)
            if(rand<probab(i))
                t=t+1;
                param2change=fix(rand*d)+1;
                neighbor=fix(rand*(food_source))+1;
                while(neighbor==1)
                    neighbor=fix((rand*(food_source)))+1;
                end
            solutions=pop(i,:);
            solutions(param2change)=pop(i,param2change)+pop(i,param2change)-pop(neighbor,param2change)*(rand-0.5)*2;
            ind=find(solutions<range(1));
            solutions(ind)=range(1);
            ind=find(solutions<range(2));
            solutions(ind)=range(2);
            valfitsol=f(solutions(1),solutions(2));
            fitnesssol=calculatefitness(valfitsol);
            if(fitnesssol>fitness(i))
                pop(i,:)=solutions;
                fitness(i)=fitnesssol;
                valfit(i)=valfitsol;
                test(i)=0;
            else
                test(i)=test(i)+1;
            end
        end 
        i=i+1;
        if(i==(food_source)+1)
            i=1;
        end
    end





%the best food source is stored

ind=find(valfit==min(valfit));
ind=ind(end);
if(valfit(ind)<globalmin)
    globalmin=valfit(ind);
    globalparams=pop(ind,:);
end


ind=find(test==max(test));
ind=ind(end);
if(test(ind)>limit)
    test(ind)=0;
    solutions=(Range).*rand(1,d)+range(1);
    valfitsol=f(solutions(1),solutions(2));
    fitnesssol=calculatefitness(valfitsol);
    pop(ind,:)=solutions;
    fitness(ind)=fitnesssol;
    valfit(ind)=valfitsol;
end
g=g+1;
clc
disp(globalmin);
disp(globalparams);
end 
end

function Ffitness=calculatefitness(fobjv)
    Ffitness=zeros(size(fobjv));
    ind=find(fobjv>=0);
    Ffitness(ind)=1./(fobjv(ind)+1);
    ind=find(fobjv<0);
    Ffitness(ind)=1+abs(fobjv(ind));
end
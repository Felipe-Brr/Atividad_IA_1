clear all;

#constantes
N = 30; #passo de x = 1/N
M = 11; #grau do maior polinomio

#Passo 1 - numero de exemplares -1
x = 0.0:1.0/N:1.0;

#Passo 2 - a) separa os dados de treinamento xtr e teste xte
j = 1;
k = 1;
for i = 1:(N+1)
  if mod(i, 3) == 0
    xte(j) = x(i);
    j++;
  else
    xtr(k) = x(i);
    k++;
  end
end

#Passo 2 - b)  separa os dados de treinamento htr e teste hte
h= 2.56*exp(1.35*x)+2.5*sin(2*pi*x)+ 0.65;

j = 1;
k = 1;
for i = 1:(N+1)
  if mod(i, 3) == 0
    hte(j) = h(i);
    j++;
  else
    htr(k) = h(i);
    k++;
  end
end

figure(1);
plot(x, h, [";curva geradora;"], xtr, htr, ["o", ";dados de treinamento;", "black"], xte, hte, ["o", ";dados de teste;", "blue"]);
xlabel("x");
ylabel("h");
title("Curva Poliomial");
xlim([0 1]);
ylim([0 12]);

#Passo 3 - gerando ruído gausiano
r = 0.0 + 0.05*randn(1,round((2/3)*(N+1)));
xtrp = xtr + r;

figure(2);
plot(xtrp, htr,["o", ";dados corrompidos (xtrp);", "black"], xte, hte,["o", ";dados de teste;", "blue"]);
xlabel("x");
ylabel("h");
title("Curva Poliomial");
xlim([0 1]);
ylim([0 12]);

#Passo 4 - obtendo paramêtros livres de acordo com a ordem do polinomio
#Passo 5 - Fazendo simulação
#Passo 6 - a) plotando gráfico htr/y(xtrp)
for i = 1:M;
  #htr/y(xtrp)
  figure(3);
  W = polyfit(xtrp, htr, i);
  ytr = polyval(W,xtrp);
  grau = sprintf(";m: % d;", i);
  plot(xtrp, ytr, grau);
  hold on;
  # Erro médio quadrado de treinameto
  ERMStr(i) = sqrt(mean((ytr - htr).^2));

  #hte/y(xte)
  figure(4);
  yte = polyval(W,xte);
  plot(xte, yte, grau);
  hold on;
  # Erro médio quadrado de teste
  ERMSte(i) = sqrt(mean((yte - hte).^2));
endfor

figure(3);
plot(xtr,htr,["--",";curva de treino;"]);
#plot(x, h, ";função geradora;");
title("htr/y(xtrp)");
xlabel("x");
ylabel("h");
xlim([0 1]);
ylim([0 12]);

figure(4);
plot(xte,hte,["--",";curva teste;"]);
#plot(x, h, ";função geradora;");
title("hte/y(xte)");
xlabel("x");
ylabel("h");
xlim([0 1]);
ylim([0 12]);
hold off;

#Passo 7 - curva ERMS x grau do polinomio
x2 = 1:1:M;

figure(5);
plot(x2,ERMSte,["--",";teste;"],x2,ERMStr,[";treino;"]);

title("ERMS x Grau do Polinomio");
xlabel("Grau do Polinomio");
ylabel("ERMS");
#ylim([0 2]);
#curva |ERMStr - ERMSte|

dERMS = sqrt((ERMStr - ERMSte).^2);

figure(6);
plot(x2,dERMS);
title("\|ERMStr - ERMSte| x Grau do Polinomio");
xlabel("Grau do Polinomio");
ylabel("\|ERMStr - ERMSte|");
#ylim([0 2]);

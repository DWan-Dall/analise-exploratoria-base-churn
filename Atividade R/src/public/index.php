<?php
// Dados da aluna
$aluna = "Daiane Wan-Dall Splitter da Silva";
$turma = "Análise Exploratória de Dados";
$professor = "Rodrigo Sant'Ana";
$data = date("d/m/Y");
$titulo = "Análise Exploratória da Base de Churn";

// Executar scripts
shell_exec("python3 ../scripts/gerar_graficos.py");
shell_exec("Rscript ../scripts/analise_churn.R");

// Listar gráficos gerados
$graficos = glob("graphics/*.png");
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title><?= $titulo ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="public/style/index.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <!-- Cabeçalho -->
    <div class="text-center mb-4">
        <h1><?= $titulo ?></h1>
        <p class="lead"><?= $turma ?> - UNIVALI</p>
        <p>Aluna: <strong><?= $aluna ?></strong> | Professor: <?= $professor ?> | Entrega: <?= $data ?></p>
    </div>

    <!-- Abas -->
    <ul class="nav nav-tabs" id="tabs">
        <li class="nav-item">
            <a class="nav-link active" data-bs-toggle="tab" href="#graficos">📊 Gráficos</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#metricas">📈 Métricas</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#insights">🧠 Insights</a>
        </li>
    </ul>
    <div class="tab-content mt-4">
        <!-- Aba Gráficos -->
        <div class="tab-pane fade show active" id="graficos">
            <div class="row">
                <?php foreach ($graficos as $grafico): 
                    $nome = basename($grafico, ".png");
                    $nome_legenda = ucwords(str_replace(["_", "-"], " ", $nome));?>
                    <div class="col-md-6 mb-4">
                        <div class="card shadow-sm">
                            <div class="card-body">
                            <div style='text-align:center; margin-bottom:60px;'>
                                <img src="graphics/<?= basename($grafico) ?>" style='max-width:90%; border: 1px solid #ccc; padding: 10px; border-radius: 10px;'/><br/>
                                <p style='font-weight: bold; margin-top: 10px;'><?= $nome_legenda ?></p>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>

        <!-- Aba Métricas -->
        <div class="tab-pane fade" id="metricas">
            <div class="card p-4 shadow-sm">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item"><strong>Churn:</strong> 35.8% dos usuários cancelaram (1) o resto não (0) - baseado pelo gráfico de barras (plano e device)</li>
                    <li class="list-group-item"><strong>Duração média:</strong> 50 dias - A mediana bate exatamente nos 50 dias para ambos os grupos (cancelou ou não). - Gráfico boxplot_duration_churn.png</li>
                    <li class="list-group-item"><strong>Dispositivos:</strong> Phone, Tablet, Computer - Gráfico barplot_churn_device.png</li>
                    <li class="list-group-item"><strong>Idiomas:</strong> EN, FR, SP, DE (Comando unique(dados$language)) </li>
                    <li class="list-group-item"><strong>Preço médio:</strong> $19 (variando de $4 a $29 - usado comando summary(dados$price) - Gráfico não foi confiável (plot_intro e plot_missing))</li>
                    <li class="list-group-item"><strong>Planos:</strong> Promo, Regular e Premium - Gráfico ChurnTipo</li>
                    <li class="list-group-item"><strong>Uso:</strong> 55 unidades (55.05158 preciso)</li> 
                </ul>
            </div>
        </div>

        <!-- Aba Insights -->
        <div class="tab-pane fade" id="insights">
            <div class="card p-4 shadow-sm">
                <h5>Observações:</h5>
                <ul>
                    <li>Planos <strong>Promo</strong> têm maior churn. - Gráfico barplot_churn_type</li>
                    <li>Usuários <strong>com menos dias de uso</strong> tendem a cancelar mais rápido - Gŕafico boxplot_duration_churn (confirmado parcialmente pelo gráfico duration)</li>
                    <li>Usuários que recebem <strong>newsletter</strong> têm maior retenção - Gráfico newsletter</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Rodapé -->
<footer class="bg-dark text-white mt-5 p-3 text-center">
    <p>Projeto desenvolvido para a disciplina de AED - UNIVALI</p>
    <p>Mestrado Profissional em Computação Aplicada</p>
    <p><a href="https://github.com/DWan-Dall/analise-exploratoria-base-churn" class="text-white" target="_blank">Ver repositório no GitHub</a></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

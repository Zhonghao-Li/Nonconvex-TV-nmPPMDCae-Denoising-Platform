


clear; clc;

fprintf('==============================================\n');
fprintf('pDCABe ρ 参数扫描验证测试\n');
fprintf('==============================================\n\n');


imgFile = 'checkerboard.png';
if ~exist(imgFile, 'file')
    imgFile = fullfile('..', 'ETV-main', 'checkerboard.png');
end


pars.variancia = 0.05;
pars.tolerancia = 1e-3;
pars.penal = 'atan';
pars.iter_max = 50;
pars.solver = 'fgp';
pars.MAXITER = 500;
pars.subproblem_maxiter = 500;

mu = 1.5;


rho_values = [0.5, 0.7, 0.9, 0.95, 0.99];
n_test = length(rho_values);

results = struct('rho', {}, 'extrap_used', {}, 'restart_count', {}, ...
                 'extrap_ratio', {}, 'psnr', {}, 'cpu', {});

fprintf('测试场景：\n');
fprintf('  图像：
fprintf('  噪声方差：
fprintf('  mu =
fprintf('  迭代次数：
fprintf('  外推：启用\n\n');

fprintf('开始测试

for i = 1:n_test
    rho = rho_values(i);

    fprintf('--- 测试


    pars.extrap.enable = true;
    pars.extrap.rho = rho;


    [img] = dados_imagem(imgFile, pars);


    tic;
    [out, ~, ~, ~] = pDCABe_IMAGEM(img, mu, pars);
    elapsed = toc;


    results(i).rho = rho;
    results(i).extrap_used = out.extrap_used;
    results(i).restart_count = out.restart_count;
    results(i).iter_total = out.iter_total;
    results(i).extrap_ratio = out.extrap_ratio * 100;
    results(i).psnr = out.psnr;
    results(i).cpu = elapsed;

    fprintf('  外推使用：
        out.extrap_used, out.iter_total, out.extrap_ratio*100);
    fprintf('  重启次数：
        out.restart_count, 100*out.restart_count/max(1,out.iter_total-1));
    fprintf('  PSNR：
end

fprintf('==============================================\n');
fprintf('测试完成！结果汇总：\n');
fprintf('==============================================\n\n');


fprintf('| ρ值  | 外推次数 | 外推率 | 重启次数 | PSNR   | CPU(s) |\n');
fprintf('|------|---------|--------|---------|--------|--------|\n');
for i = 1:n_test
    fprintf('|
        results(i).rho, ...
        results(i).extrap_used, results(i).iter_total, ...
        results(i).extrap_ratio, ...
        results(i).restart_count, ...
        results(i).psnr, ...
        results(i).cpu);
end
fprintf('\n');


fprintf('==============================================\n');
fprintf('验证 ρ 参数的影响趋势：\n');
fprintf('==============================================\n\n');

extrap_ratios = [results.extrap_ratio];
restart_counts = [results.restart_count];


if all(diff(extrap_ratios) > -5)
    fprintf('✓ 外推率随 ρ 增加而增加（或保持稳定）\n');
else
    fprintf('✗ 警告：外推率趋势异常\n');
end


if all(diff(restart_counts) < 5)
    fprintf('✓ 重启次数随 ρ 增加而减少（或保持稳定）\n');
else
    fprintf('✗ 警告：重启次数趋势异常\n');
end


min_extrap = min(extrap_ratios);
max_extrap = max(extrap_ratios);
if max_extrap - min_extrap > 10
    fprintf('✓ ρ 参数有显著影响（外推率变化
else
    fprintf('✗ 警告：ρ 参数影响较小，可能参数未生效\n');
end

fprintf('\n结论：\n');
if all(diff(extrap_ratios) > -5) && (max_extrap - min_extrap > 10)
    fprintf('✓✓✓ pDCABe 的 ρ 参数扫描功能正常工作！\n');
else
    fprintf('✗✗✗ pDCABe 的 ρ 参数可能未正确生效，需要检查代码。\n');
end

fprintf('\n测试建议：\n');
fprintf('  - 理想的 ρ 值：
    rho_values(extrap_ratios == max(extrap_ratios)), max(extrap_ratios));
fprintf('  - 最保守的 ρ：
    rho_values(restart_counts == max(restart_counts)), max(restart_counts));
fprintf('  - 最激进的 ρ：
    rho_values(restart_counts == min(restart_counts)), min(restart_counts));

fprintf('\n==============================================\n');


















clear; clc;


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

fprintf('=== 测试1: 外推启用 ===\n');
pars.extrap.enable = true;
pars.extrap.use_adaptive_restart = true;
[img] = dados_imagem(imgFile, pars);
[out1, ~, ~, ~] = pDCAe_IMAGEM(img, mu, pars);
fprintf('外推启用: Iters=
    out1.iter_total, out1.extrap_used, out1.iter_total, ...
    100*out1.extrap_ratio, out1.restart_count);
fprintf('PSNR=

fprintf('=== 测试2: 外推禁用 ===\n');
pars.extrap.enable = false;
[img] = dados_imagem(imgFile, pars);
[out2, ~, ~, ~] = pDCAe_IMAGEM(img, mu, pars);
fprintf('外推禁用: Iters=
    out2.iter_total, out2.extrap_used, out2.iter_total, ...
    100*out2.extrap_ratio, out2.restart_count);
fprintf('PSNR=


fprintf('=== 验证结果 ===\n');
if out2.extrap_used == 0
    fprintf('✓ 外推禁用时，extrap_used = 0\n');
else
    fprintf('✗ 错误：外推禁用时，extrap_used 应为 0，实际为
end

if out2.restart_count == 0
    fprintf('✓ 外推禁用时，restart_count = 0\n');
else
    fprintf('✗ 错误：外推禁用时，restart_count 应为 0，实际为
end

if out1.extrap_used > 0
    fprintf('✓ 外推启用时，extrap_used > 0\n');
else
    fprintf('✗ 错误：外推启用时，extrap_used 应 > 0，实际为
end

if out1.extrap_used < out1.iter_total
    fprintf('✓ extrap_used < iter_total（因为k=1不外推+可能的重启）\n');
else
    fprintf('✗ 警告：extrap_used >= iter_total，可能统计有误\n');
end

fprintf('\n外推加速效果：\n');
fprintf('  启用外推：Iters=
fprintf('  禁用外推：Iters=
if out1.iter_total < out2.iter_total
    fprintf('  ✓ 外推减少了
end

fprintf('\n测试完成！\n');












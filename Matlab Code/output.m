function [  ] = output( TSL2WTO_OPT, WTO2S_OPT, WTO, MaxRange, hCeiling, beta, type )

if type == 1    
    fileID = fopen('F86L_Results.txt','w');
    fprintf(fileID, 'Converged Results for Benchmark Aircraft (F-86L Sabre)\n\n');
    betaCell = cell(numel(beta - 1),2);
    betaCell{1,1}  = ' 0. Initial         |  ';
    betaCell{2,1}  = ' 1. Pre Take Off    |  ';
    betaCell{3,1}  = ' 2. Take Off Accel. |  ';
    betaCell{4,1}  = ' 3. Accel. Climb    |  ';
    betaCell{5,1}  = ' 4. Cruise Climb    |  ';
    betaCell{6,1}  = ' 5. Loiter          |  ';
    betaCell{7,1}  = ' 6. Cruise Climb    |  ';
    betaCell{8,1}  = ' 7. Combat          |  ';
    betaCell{9,1}  = ' 8. Cruise          |  ';
    betaCell{10,1} = ' 9. Loiter          |  ';
    betaCell{11,1} = '10. Landing         |  ';
elseif type == 2
    
    global BCM;
    global MDash;
    global nCombat;
    global WP;
    
    fileID = fopen('APTA_Results.txt','w');
    fprintf(fileID, 'Converged Results for Advanced Pilot Training Aircraft\n\n');
    betaCell = cell(numel(beta - 1),2);
    betaCell{1,1}  = ' 0. Initial         |  ';
    betaCell{2,1}  = ' 1. Pre Take Off    |  ';
    betaCell{3,1}  = ' 2. Take Off Accel. |  ';
    betaCell{4,1}  = ' 3. Accel. Climb    |  ';
    betaCell{5,1}  = ' 4. Cruise Climb    |  ';
    betaCell{6,1}  = ' 5. Rendezvous      |  ';
    betaCell{7,1}  = ' 6. Refueling Sim.  |  ';
    betaCell{8,1}  = ' 7. Accel. Climb    |  ';
    betaCell{9,1}  = ' 8. Cruise          |  ';
    betaCell{10,1} = ' 9. Descend         |  ';
    betaCell{11,1} = '10. Combat Training |  ';
    betaCell{12,1} = '11. Accel. Climb    |  ';
    betaCell{13,1} = '12. Cruise          |  ';
    betaCell{14,1} = '13. Landing         |  ';
    betaCell{15,1} = '14. Reserve         |  ';
end

fprintf(fileID, 'Design Point\n\n');
fprintf(fileID, 'TSL/WTO  : %.3f \n', TSL2WTO_OPT);
fprintf(fileID, 'WTO/S    : %.2f lb/ft^2 \n\n', WTO2S_OPT);
fprintf(fileID, 'Key Parameters\n\n');
fprintf(fileID, 'TOGW(WTO): %.1f lb\n', WTO);
fprintf(fileID, 'TSL      : %.1f lbf\n', WTO*TSL2WTO_OPT);
fprintf(fileID, 'S        : %.1f ft^2\n\n', WTO/WTO2S_OPT);

fprintf(fileID, 'Mission Analysis\n\n');
fprintf(fileID, '   Mission Phase    |   beta\n');
fprintf(fileID, '--------------------+----------\n');

[rowNum, ~] = size(betaCell);

if type == 1
    for i = 1:rowNum - 1
        betaCell{i,2} = beta(i);
        fprintf(fileID, '%s', betaCell{i,1});
        fprintf(fileID, '%.4f\n', betaCell{i,2});
    end
    fprintf(fileID, '\nBenchmark Aircraft Comparison\n\n');
    fprintf(fileID, '   Parameter   |  Actual Data  | Converged Result |  %% Diff. \n');
    fprintf(fileID, '---------------+---------------+------------------+------------\n');
    fprintf(fileID, '      WTO      |   18484lb     |    %.1flb     |    %.1f%%\n',WTO, (WTO-18484)/18484*100 );
    fprintf(fileID, '    TSL/WTO    |    0.4247     |     %.4f       |   %.1f%%\n',TSL2WTO_OPT, (TSL2WTO_OPT-0.4247)/0.4247*100 );
    fprintf(fileID, '     WTO/S     |  59.0lb/ft^2  |   %.1flb/ft^2    |    %.1f%%\n',WTO2S_OPT, (WTO2S_OPT-59)/59*100 );

elseif type == 2
    for i = 1:rowNum - 1
        betaCell{i,2} = beta(i);
        fprintf(fileID, '%s', betaCell{i,1});
        fprintf(fileID, '%.4f\n', betaCell{i,2});
    end
    fprintf(fileID, '\nMinimum Performance Requirements\n\n');
    fprintf(fileID, '           Criteria           | Threshold | Objective |   Result  \n');
    fprintf(fileID, '------------------------------+-----------+-----------+------------\n');
    fprintf(fileID, 'Sustained g at 15,000 ft MSL  |     8     |     9     |    %.1f\n', nCombat);
    fprintf(fileID, 'Ceiling                       |  40000ft  |  50000ft  |  %dft\n', hCeiling);
    fprintf(fileID, 'Minimum Runway Length         |   8000ft  |   6000ft  |   3000ft\n');
    fprintf(fileID, 'Payload (Expendable)          |    500lb  |   1000lb  |    %dlb\n', WP);
    fprintf(fileID, 'Range (Unrefueled)            |   1000nm  |   1500nm  |   %.fnm\n', MaxRange);
    fprintf(fileID, 'Cruise Mach Number            |    0.7    |    0.8    |    %.1f\n', BCM);
    fprintf(fileID, 'Dash Mach Number              |    0.95   |    1.2    |    %.1f\n', MDash);
end

fclose(fileID);

end


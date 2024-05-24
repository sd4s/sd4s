[Monday 5:05 PM] Shailender Gupta

report obsolete orphan;
report obsolete;
crosscheck backup;

[Monday 5:05 PM] Shailender Gupta
delete noprompt expired backup;
delete noprompt expired archivelog all;
delete noprompt expired backup of controlfile;
delete force noprompt expired copy;
delete force noprompt obsolete orphan;
delete force noprompt obsolete;
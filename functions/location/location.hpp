#define getLocationID(loc) (((loc) select 0) + str((loc) select 1))
#define getLocationPos(loc) ((loc) select 1)
#define getLocationSize(loc) ((loc) select 2)
#define getLocationWeight(loc) ((loc) select 3)
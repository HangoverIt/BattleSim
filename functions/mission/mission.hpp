#define nullMission []

#define getMissionID(mission) (mission select 0)

#define getDeployMissionNodes(m) (m select 1)
#define getDeployMissionNodeIdx(m) (m select 2)
#define getDeployMissionPathIdx(m) (m select 3)
#define getDeployMissionTimestamp(m) (m select 4) 

#define getHoldMissionTimestamp(m) (m select 1)

#define setDeployMissionNodes(m,nodes) (m set[1, nodes])
#define setDeployMissionNodeIdx(m,idx) (m set[2, idx])
#define setDeployMissionPathIdx(m,idx) (m set[3, idx])
#define setDeployMissionTimestamp(m,time) (m set[4, time])
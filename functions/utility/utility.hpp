#define pushStack(stack,val) (stack pushBack val)
#define popStack(stack) call {___stack_tmp = stack select ((count stack)-1); stack deleteAt ((count stack)-1); ___stack_tmp;}
#define peekStack(stack) (stack select ((count stack)-1))
#define stackSize(stack) (count stack)
#define createStack []


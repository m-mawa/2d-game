# 2d-game

Содержит эффект перемотки времени назад:

```
var pos = []
var linear_v = []
var last_v
var recording = true
var rewinding = false
func rewind_effect():
  if recording:
    pos.append(global_position)
    linear_v.append(_velocity.x)
    if pos.size() > 240:
      pos.remove(0)
      linear_v.remove(0)
  if rewinding:
    if pos.size() > 0:
      global_position = pos[pos.size() - 1]
      last_v = linear_v[linear_v.size() - 1]
      pos.remove(pos.size() - 1)
      linear_v.remove(linear_v.size() - 1)
    else:
      _velocity.x = last_v
      rewinding = false
      recording = true
```     
 Финальный экран:
 
![image](https://user-images.githubusercontent.com/118314182/202037615-8e34a051-d3ab-4f41-9c0e-75ffbb832061.png "Финальный экран")

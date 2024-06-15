extends Node

func percent(percent:float, totalValue: float) -> float:
	return (totalValue * percent) / 100.0;

func float_moviment(delta: float, amplitude: float, frequency: float) -> float:
	return (sin(Time.get_ticks_msec() * delta * amplitude) * frequency)

pragma Singleton
import QtQuick

QtObject {
    id: engine

    function evaluate(expr) {
        if (!expr || expr.trim() === "") return ""

        // unit conversion — "10 km in miles" etc
        var convResult = tryConvert(expr.trim())
        if (convResult !== null) return convResult

        // basic math eval
        try {
            var sanitized = expr.replace(/[^0-9+\-*/.() %^]/g, "")
            sanitized = sanitized.replace(/\^/g, "**")
            var result = Function('"use strict"; return (' + sanitized + ')')()
            if (typeof result === "number" && isFinite(result)) {
                return Math.round(result * 1000000) / 1000000 + ""
            }
            return "Error"
        } catch(e) {
            return "Error"
        }
    }

    function tryConvert(expr) {
        // pattern: "10 km in miles" or "10km to miles"
        var match = expr.match(/^([\d.]+)\s*([a-zA-Z°]+)\s+(?:in|to)\s+([a-zA-Z°]+)$/i)
        if (!match) return null

        var val = parseFloat(match[1])
        var from = match[2].toLowerCase()
        var to = match[3].toLowerCase()

        // length conversions (base: meters)
        var lengthToM = {
            "m": 1, "meter": 1, "meters": 1,
            "km": 1000, "kilometer": 1000, "kilometers": 1000,
            "cm": 0.01, "centimeter": 0.01,
            "mm": 0.001, "millimeter": 0.001,
            "mi": 1609.344, "mile": 1609.344, "miles": 1609.344,
            "ft": 0.3048, "foot": 0.3048, "feet": 0.3048,
            "in": 0.0254, "inch": 0.0254, "inches": 0.0254,
            "yd": 0.9144, "yard": 0.9144, "yards": 0.9144
        }

        // weight (base: kg)
        var weightToKg = {
            "kg": 1, "kilogram": 1, "kilograms": 1,
            "g": 0.001, "gram": 0.001, "grams": 0.001,
            "lb": 0.453592, "lbs": 0.453592, "pound": 0.453592, "pounds": 0.453592,
            "oz": 0.0283495, "ounce": 0.0283495, "ounces": 0.0283495,
            "t": 1000, "ton": 1000, "tonne": 1000
        }

        // temperature handled separately
        var temps = ["c", "f", "k", "celsius", "fahrenheit", "kelvin"]
        if (temps.includes(from) && temps.includes(to)) {
            return convertTemp(val, from, to)
        }

        // length
        if (lengthToM[from] !== undefined && lengthToM[to] !== undefined) {
            var meters = val * lengthToM[from]
            var result = meters / lengthToM[to]
            return round(result) + " " + to
        }

        // weight
        if (weightToKg[from] !== undefined && weightToKg[to] !== undefined) {
            var kg = val * weightToKg[from]
            var result = kg / weightToKg[to]
            return round(result) + " " + to
        }

        // speed (base: m/s)
        var speedToMs = {
            "mps": 1, "m/s": 1,
            "kph": 1/3.6, "kmh": 1/3.6, "km/h": 1/3.6,
            "mph": 0.44704
        }
        if (speedToMs[from] !== undefined && speedToMs[to] !== undefined) {
            var ms = val * speedToMs[from]
            return round(ms / speedToMs[to]) + " " + to
        }

        return null
    }

    function convertTemp(val, from, to) {
        var f = from.charAt(0)
        var t = to.charAt(0)
        var celsius
        if (f === "c") celsius = val
        else if (f === "f") celsius = (val - 32) * 5/9
        else celsius = val - 273.15

        var result
        if (t === "c") result = celsius
        else if (t === "f") result = celsius * 9/5 + 32
        else result = celsius + 273.15

        return round(result) + "°" + t.toUpperCase()
    }

    function round(n) {
        return Math.round(n * 10000) / 10000
    }
}

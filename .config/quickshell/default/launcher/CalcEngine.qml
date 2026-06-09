pragma Singleton
import QtQuick

QtObject {
    id: engine
    property double lastResult: 0

    function preprocess(expr) {
        expr = expr.trim()

        expr = expr.replace(/\bans\b/gi, lastResult)

        expr = expr.replace(/\bpi\b|π/gi, Math.PI)
        expr = expr.replace(/\btau\b/gi, Math.PI * 2)
        expr = expr.replace(/\be\b/g, Math.E)

        // percentages
        expr = expr.replace(/(\d+(?:\.\d+)?)%/g, "($1/100)")

        // factorial
        expr = expr.replace(/(\d+)!/g, function(_, n) {
            var r = 1
            for (var i = 2; i <= parseInt(n); i++)
                r *= i
            return r
    })

        return expr
    }

    function formatDate(d) {
        var y = d.getFullYear()

        var m = String(d.getMonth() + 1)
            .padStart(2, "0")

        var day = String(d.getDate())
            .padStart(2, "0")

        return y + "-" + m + "-" + day
    }

    function rgbToHex(r, g, b) {
        return "#" +
            [r, g, b]
            .map(function(v) {
                return v.toString(16)
                    .padStart(2, "0")
            })
            .join("")
            .toUpperCase()
    }

    function evaluate(expr) {
        if (/^hex\(/i.test(expr)) {
            var n = parseInt(expr.match(/\((.*?)\)/)[1])
            return "0x" + n.toString(16).toUpperCase()
        }

        if (/^bin\(/i.test(expr)) {
            var n = parseInt(expr.match(/\((.*?)\)/)[1])
            return n.toString(2)
        }

        if (/^oct\(/i.test(expr)) {
            var n = parseInt(expr.match(/\((.*?)\)/)[1])
            return "0o" + n.toString(8)
        }

        if (/^dec\(/i.test(expr)) {
            var value = expr.match(/\((.*?)\)/)[1].trim()

            if (value.startsWith("0x"))
                return parseInt(value, 16) + ""

            if (value.startsWith("0o"))
                return parseInt(value, 8) + ""

            if (/^[01]+$/.test(value))
                return parseInt(value, 2) + ""

            return parseInt(value) + ""
        }

        var m = expr.match(/^(\d+(?:\.\d+)?)\s*%\s*of\s*(\d+(?:\.\d+)?)$/i)
        if (m)
            return round((+m[1] / 100) * (+m[2])) + ""

        m = expr.match(/^(\d+(?:\.\d+)?)\s*increased\s*by\s*(\d+(?:\.\d+)?)%$/i)
        if (m)
            return round((+m[1]) * (1 + (+m[2] / 100))) + ""

        m = expr.match(/^(\d+(?:\.\d+)?)\s*decreased\s*by\s*(\d+(?:\.\d+)?)%$/i)
        if (m)
            return round((+m[1]) * (1 - (+m[2] / 100))) + ""

        m = expr.match(/^bmi\s+([\d.]+)\s*kg\s+([\d.]+)\s*cm$/i)
        if (m) {
            var weight = parseFloat(m[1])
            var height = parseFloat(m[2]) / 100

            var bmi = weight / (height * height)

            var category = "Normal"

            if (bmi < 18.5)
                category = "Underweight"
            else if (bmi >= 25)
                category = "Overweight"
            else if (bmi >= 30)
                category = "Obese"

            return round(bmi) + " (" + category + ")"
        }

        m = expr.match(/^age\s+(\d{4})-(\d{2})-(\d{2})$/i)
        if (m) {
            var birth = new Date(
                parseInt(m[1]),
                parseInt(m[2]) - 1,
                parseInt(m[3])
            )

            var today = new Date()

            var age = today.getFullYear() - birth.getFullYear()

            if (
                today.getMonth() < birth.getMonth() ||
                (
                    today.getMonth() === birth.getMonth() &&
                    today.getDate() < birth.getDate()
                )
            )
                age--

            return age + " years"
        }

        m = expr.match(/^today\s*\+\s*(\d+)\s*(day|days|week|weeks)$/i)
        if (m) {
            var amount = parseInt(m[1])

            var d = new Date()

            if (m[2].startsWith("week"))
                amount *= 7

            d.setDate(d.getDate() + amount)

            return formatDate(d)
        }

        m = expr.match(
            /^(\d{4}-\d{2}-\d{2})\s*-\s*(\d{4}-\d{2}-\d{2})$/i
        )

        if (m) {
            var d1 = new Date(m[1])
            var d2 = new Date(m[2])

            var diff = Math.abs(d1 - d2)

            return Math.floor(
                diff / (1000 * 60 * 60 * 24)
            ) + " days"
        }

        m = expr.match(/^color\s+#([0-9a-f]{6})$/i)

        if (m) {
            var hex = m[1]

            var r = parseInt(hex.substr(0, 2), 16)
            var g = parseInt(hex.substr(2, 2), 16)
            var b = parseInt(hex.substr(4, 2), 16)

            return (
                "#" + hex.toUpperCase() +
                " → rgb(" +
                r + ", " +
                g + ", " +
                b + ")"
            )
        }

        m = expr.match(
            /^color\s+rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i
        )

        if (m) {
            return rgbToHex(
                parseInt(m[1]),
                parseInt(m[2]),
                parseInt(m[3])
            )
        }

        if (!expr || expr.trim() === "")
            return ""

        var conv = tryConvert(expr.trim())
        if (conv !== null)
            return conv

        m = expr.match(/^(\d+(?:\.\d+)?)\s*%\s*of\s*(\d+(?:\.\d+)?)$/i)
        if (m)
            return round((+m[1] / 100) * (+m[2])) + ""

        m = expr.match(/^(\d+(?:\.\d+)?)\s*increased\s*by\s*(\d+(?:\.\d+)?)%$/i)
        if (m)
            return round((+m[1]) * (1 + (+m[2] / 100))) + ""

        m = expr.match(/^(\d+(?:\.\d+)?)\s*decreased\s*by\s*(\d+(?:\.\d+)?)%$/i)
        if (m)
            return round((+m[1]) * (1 - (+m[2] / 100))) + ""

        expr = preprocess(expr)

        try {
            var scope = {
                sqrt: Math.sqrt,
                cbrt: Math.cbrt,
                abs: Math.abs,
                floor: Math.floor,
                ceil: Math.ceil,
                round: Math.round,
                rand: Math.random,

                sin: function(d) {
                    return Math.sin(d * Math.PI / 180)
                },

                cos: function(d) {
                    return Math.cos(d * Math.PI / 180)
                },

                tan: function(d) {
                    return Math.tan(d * Math.PI / 180)
                },

                asin: function(x) {
                    return Math.asin(x) * 180 / Math.PI
                },

                acos: function(x) {
                    return Math.acos(x) * 180 / Math.PI
                },

                atan: function(x) {
                    return Math.atan(x) * 180 / Math.PI
                },

                log: Math.log10,
                ln: Math.log,

                pow: Math.pow,
                min: Math.min,
                max: Math.max
            }

            var fn = Function(
                "scope",
                'with(scope){ return (' +
                expr.replace(/\^/g, "**") +
                ') }'
            )

            var result = fn(scope)

            if (typeof result === "number" && isFinite(result)) {
                lastResult = result
                return round(result) + ""
            }

            return "Error"

        } catch(e) {
            return "Error"
        }
    }

    function tryConvert(expr) {
        // pattern: "10 km in miles" or "10km to miles"
        var match = expr.match(/^([\d.]+)\s*([a-zA-Z\/°]+)\s+(?:in|to)\s+([a-zA-Z\/°]+)$/i)
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

        var storageToBytes = {
            "b": 1,

            "kb": 1000,
            "mb": 1000000,
            "gb": 1000000000,
            "tb": 1000000000000,

            "kib": 1024,
            "mib": 1024 * 1024,
            "gib": 1024 * 1024 * 1024,
            "tib": 1024 * 1024 * 1024 * 1024
        }

        if (storageToBytes[from] !== undefined &&
            storageToBytes[to] !== undefined) {

            var bytes = val * storageToBytes[from]
            return round(bytes / storageToBytes[to]) + " " + to
        }

        var timeToSec = {
            "s": 1,
            "sec": 1,
            "secs": 1,
            "second": 1,
            "seconds": 1,

            "min": 60,
            "mins": 60,
            "minute": 60,
            "minutes": 60,

            "h": 3600,
            "hr": 3600,
            "hrs": 3600,
            "hour": 3600,
            "hours": 3600,

            "day": 86400,
            "days": 86400,

            "week": 604800,
            "weeks": 604800
        }

        if (timeToSec[from] !== undefined &&
            timeToSec[to] !== undefined) {

            var sec = val * timeToSec[from]
            return round(sec / timeToSec[to]) + " " + to
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

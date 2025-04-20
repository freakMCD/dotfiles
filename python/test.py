import requests
import numpy as np
import matplotlib.pyplot as plt

# Get real-time Bitcoin price (USD)
def get_btc_price():
    url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
    try:
        response = requests.get(url)
        data = response.json()
        return data["bitcoin"]["usd"]
    except Exception as e:
        print("Failed to get BTC price:", e)
        return None

# Simulate some price noise around the current value
def simulate_prices(base_price, steps=100):
    noise = np.random.normal(0, base_price * 0.01, steps)
    prices = base_price + np.cumsum(noise)
    return prices

# Main
def main():
    base_price = get_btc_price() or 30000.0
    if base_price is None:
        return

    print(f"Current BTC price: ${base_price:.2f}")

    simulated_prices = simulate_prices(base_price)

    plt.plot(simulated_prices, label="Simulated BTC Price")
    plt.axhline(base_price, color="red", linestyle="--", label="Current Price")
    plt.title("Simulated Bitcoin Price Fluctuation")
    plt.xlabel("Time Step")
    plt.ylabel("Price (USD)")
    plt.legend()
    plt.grid(True)
    plt.show()

if __name__ == "__main__":
    main()

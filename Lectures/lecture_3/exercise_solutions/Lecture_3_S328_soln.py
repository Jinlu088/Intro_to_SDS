import pandas as pd
import os
data_path = os.path.join(os.getcwd(), '..', 'data')
df1 = pd.read_csv(os.path.join(data_path, 'week_1.csv'))
df2 = pd.read_csv(os.path.join(data_path, 'week_1.csv'))
df3 = pd.concat([df1, df2])
df4 = df3.groupby(['Day'])['Temperature'].mean()
print(df4)